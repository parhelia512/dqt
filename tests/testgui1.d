// QT_MODULES: gui
module testgui1;

import qt.config;
import qt.core.coreevent;
import qt.gui.backingstore;
import qt.gui.event;
import qt.gui.guiapplication;
import qt.gui.window;
import qt.helpers;

QGuiApplication app;
version (Android)
{}
else
shared static this()
{
    import core.runtime;
    import core.stdcpp.new_;

    app = cpp_new!QGuiApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
}

class TestWindow : QWindow
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this()
    {
        import core.stdcpp.new_;

        backingStore = cpp_new!QBackingStore(this);
        resize(400, 400);
    }
    ~this()
    {
    }

protected:
    final void renderNow()
    {
        import qt.core.namespace;
        import qt.core.rect;
        import qt.gui.brush;
        import qt.gui.color;
        import qt.gui.paintdevice;
        import qt.gui.painter;
        import qt.gui.region;

        if (!isExposed())
            return;

        auto rect = QRect(0, 0, width(), height());
        backingStore.beginPaint(QRegion(rect));

        QPaintDevice device = backingStore.paintDevice();
        auto painter = QPainter(device);
        painter.setRenderHint(QPainter.RenderHint.Antialiasing);

        painter.fillRect(QRectF(0, 0, width(), height()), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue)));
        painter.fillRect(QRectF(10, 10, 50, 50), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red)));

        painter.end();
        backingStore.endPaint();
        backingStore.flush(QRegion(rect));

        /+ emit +/ rendered();
    }

    extern(C++) override bool event(QEvent event)
    {
        if (event.type() == QEvent.Type.UpdateRequest)
        {
            renderNow();
            return true;
        }
        return QWindow.event(event);
    }

    extern(C++) override void resizeEvent(QResizeEvent event)
    {
        backingStore.resize(event.size());
    }

    extern(C++) override void exposeEvent(QExposeEvent event)
    {
        if (isExposed())
            renderNow();
    }

/+ signals +/public:
    @QSignal final void rendered() {mixin(Q_SIGNAL_IMPL_D);}

private:
    QBackingStore* backingStore;
}

unittest
{
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.string;
    import qt.core.variant;
    import qt.gui.brush;
    import qt.gui.color;
    import qt.gui.standarditemmodel;

    QStandardItem item = new QStandardItem;
    QString tmp = QString("test");
    item.setText(tmp);
    QString text = item.text();
    assert(text == "test");
    assert(qMetaTypeId!(QString)() == QVariant.Type.String);
    assert(item.data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).userType() == qMetaTypeId!(QString)());
    QVariant variant = QVariant.fromValue(text);
    item.setData(variant, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole);
    text = item.text();
    assert(text == "test");

    auto tmp2 = QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red); QBrush brush = QBrush(tmp2);
    item.setBackground(brush);
    brush = item.background();
    assert(brush.color() == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));

    QColor color2 = QColor.fromRgb(101, 102, 103, 104);
    assert(color2.red() == 101);
    assert(color2.green() == 102);
    assert(color2.blue() == 103);
    assert(color2.alpha() == 104);

    QBrush brush2 = QBrush(color2);
    item.setBackground(brush2);
    brush2 = item.background();
    assert(brush2.color() == color2);
}

unittest
{
    import qt.core.list;
    import qt.core.variant;
    import qt.gui.brush;
    import qt.gui.color;

    QBrushData* data;
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QBrush b2 = b;
        assert(data.ref_.loadRelaxed() == 3);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QVariant v = QVariant.fromValue(b);
        assert(data.ref_.loadRelaxed() == 3);
        QVariant v2 = v;
        assert(data.ref_.loadRelaxed() == 4);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QList!(QBrush) l = QList!(QBrush).create();
        l.append(b);
        assert(data.ref_.loadRelaxed() == 3);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.string;
    import qt.core.url;
    import qt.gui.textdocument;

    QTextDocument document = cpp_new!QTextDocument;
    QUrl url = QUrl(QString("https://dlang.org/"));
    assert(url.toString().toConstWString == "https://dlang.org/"w);
    document.setBaseUrl(url);
    assert(document.baseUrl().toString().toConstWString == "https://dlang.org/"w);
}

unittest
{
    import qt.core.namespace;
    import qt.core.rect;
    import qt.gui.brush;
    import qt.gui.color;
    import qt.gui.image;
    import qt.gui.painter;

    auto image = QImage(100, 100, QImage.Format.Format_ARGB32_Premultiplied);
    image.fill(/+ Qt:: +/qt.core.namespace.GlobalColor.transparent);

    {
        auto painter = QPainter(image.paintDevice);
        painter.fillRect(QRect(0, 0, image.width(), image.height()), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue)));
        painter.fillRect(QRect(10, 10, 50, 50), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red)));
    }

    assert(image.pixelColor(5, 5) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
    assert(image.pixelColor(30, 30) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));
}

version (Android)
{}
else
unittest
{
    import qt.core.eventloop;
    import qt.core.namespace;
    import qt.core.object;
    import qt.gui.color;
    import qt.gui.image;
    import qt.gui.paintdevice;
    import qt.gui.region;

    scope window = new TestWindow;
    window.show();

    scope eventLoop = new QEventLoop;
    QObject.connect(window.signal!"rendered", eventLoop.slot!"quit", /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);
    eventLoop.exec();

    QBackingStore* bs = window.backingStore;
    assert(bs !is null);

    bs.flush(QRegion(0, 0, window.width(), window.height()));

    const(QPaintDevice) device = bs.paintDevice();
    assert(device.devType() == QInternal.PaintDeviceFlags.Image);
    const(QImage)* image = static_cast!(const(QImage)*)(device);
    assert(image !is null);
    assert(!image.isNull());

    assert(image.pixelColor(5, 5) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
    assert(image.pixelColor(30, 30) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));
}
