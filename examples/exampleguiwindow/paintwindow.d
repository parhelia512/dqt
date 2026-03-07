module exampleguiwindow.paintwindow;

import qt.config;
import qt.core.coreevent;
import qt.core.global;
import qt.core.point;
import qt.core.rect;
import qt.core.string;
import qt.gui.backingstore;
import qt.gui.color;
import qt.gui.event;
import qt.gui.painter;
import qt.gui.window;
import qt.helpers;

class PaintWindow : QWindow
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this(QWindow parent = null)
    {
        import core.stdcpp.new_;
        import qt.core.namespace;
        super(parent);
        this.backingStore = cpp_new!QBackingStore(this);
        this.dotPos = typeof(this.dotPos)(200, 200);
        this.bgColor = /+ Qt:: +/qt.core.namespace.GlobalColor.white;
        this.statusText = "Click or press keys";

        setTitle("DQt QWindow Demo");
        resize(400, 400);
    }

protected:
    final void renderNow()
    {
        import qt.gui.paintdevice;
        import qt.gui.region;

        if (!isExposed())
            return;

        auto rect = QRect(0, 0, width(), height());
        backingStore.beginPaint(QRegion(rect));

        QPaintDevice device = backingStore.paintDevice();
        auto painter = QPainter(device);
        painter.setRenderHint(QPainter.RenderHint.Antialiasing);

        paint(painter, rect);

        painter.end();
        backingStore.endPaint();
        backingStore.flush(QRegion(rect));
    }

    final void paint(ref QPainter painter, ref const(QRect) rect)
    {
        import qt.core.namespace;
        import qt.gui.brush;
        import qt.gui.font;

        numPaintCalls++;

        // Background
        painter.fillRect(QRectF(0, 0, width(), height()), QBrush(bgColor));

        // Draw a circle at the current dot position
        painter.setBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
        painter.setPen(/+ Qt:: +/qt.core.namespace.PenStyle.NoPen);
        painter.drawEllipse(dotPos, 20, 20);

        // Draw status text
        painter.setPen(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.black));
        painter.setFont(QFont("Arial", 12));
        painter.drawText(10, 20, statusText);
        painter.drawText(10, rect.height() - 10, "Num paint calls: ".ptr ~ QString.number(numPaintCalls));
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

    extern(C++) override void mousePressEvent(QMouseEvent event)
    {
        import qt.core.namespace;

        dotPos = event.pos();

        if (event.button() == /+ Qt:: +/qt.core.namespace.MouseButton.LeftButton)
            statusText = QString("Left click at (%1, %2)").arg(dotPos.x()).arg(dotPos.y());
        else if (event.button() == /+ Qt:: +/qt.core.namespace.MouseButton.RightButton)
            statusText = QString("Right click at (%1, %2)").arg(dotPos.x()).arg(dotPos.y());

        requestUpdate();
    }

    extern(C++) override void mouseMoveEvent(QMouseEvent event)
    {
        import qt.core.namespace;

        // Only track when button is held
        if (event.buttons() & /+ Qt:: +/qt.core.namespace.MouseButton.LeftButton)
        {
            dotPos = event.pos();
            statusText = QString("Dragging to (%1, %2)").arg(dotPos.x()).arg(dotPos.y());
            requestUpdate();
        }
    }

    extern(C++) override void keyPressEvent(QKeyEvent event)
    {
        import qt.core.namespace;
        import qt.gui.guiapplication;

        const(int) step = 10;

        switch (event.key())
        {
        case /+ Qt:: +/qt.core.namespace.Key.Key_Left:  dotPos.rx() -= step; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_Right: dotPos.rx() += step; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_Up:    dotPos.ry() -= step; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_Down:  dotPos.ry() += step; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_R:     bgColor = /+ Qt:: +/qt.core.namespace.GlobalColor.red;   break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_G:     bgColor = /+ Qt:: +/qt.core.namespace.GlobalColor.green; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_B:     bgColor = /+ Qt:: +/qt.core.namespace.GlobalColor.cyan;  break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_W:     bgColor = /+ Qt:: +/qt.core.namespace.GlobalColor.white; break;
        case /+ Qt:: +/qt.core.namespace.Key.Key_Escape:
            QGuiApplication.quit();
            return;
        default:
            QWindow.keyPressEvent(event);
            return;
        }

        statusText = QString("Key pressed: %1  dot at (%2, %3)")
                           .arg(event.text().isEmpty() ? QString("arrow") : event.text())
                           .arg(dotPos.x())
                           .arg(dotPos.y());

        requestUpdate();
    }

private:
    QBackingStore* backingStore;
    QPoint dotPos;
    QColor bgColor;
    QString statusText;
    quint64 numPaintCalls = 0;
}

