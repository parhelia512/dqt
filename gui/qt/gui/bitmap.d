/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.gui.bitmap;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.color;
import qt.gui.image;
import qt.gui.pixmap;
import qt.gui.transform;
import qt.helpers;


/// Binding for C++ class [QBitmap](https://doc.qt.io/qt-6/qbitmap.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QBitmap
{
    public QPixmap base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use fromPixmap instead.") +/ /+ explicit +/this(ref const(QPixmap) );
/+ #endif +/
    this(int w, int h);
    /+ explicit +/this(ref const(QSize) );
    /+ explicit +/this(ref const(QString) fileName, const(char)* format = null);
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    ~this();
    }));

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+/+ QT_DEPRECATED_VERSION_X_6_0("Use fromPixmap instead.") +/ ref QBitmap operator =(ref const(QPixmap) );+/
/+ #endif +/
    /+ inline void swap(QBitmap &other) { QPixmap::swap(other); } +/ // prevent QBitmap<->QPixmap swaps
    /+auto opCast(T : QVariant)() const;+/

    pragma(inline, true) void clear() { auto tmp = QColor(qt.core.namespace.GlobalColor.color0); fill(tmp); }

    static QBitmap fromImage(ref const(QImage) image, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    /+ static QBitmap fromImage(QImage &&image, Qt::ImageConversionFlags flags = Qt::AutoColor); +/
    static QBitmap fromData(ref const(QSize) size, const(uchar)* bits,
                                QImage.Format monoFormat = QImage.Format.Format_MonoLSB);
    static QBitmap fromPixmap(ref const(QPixmap) pixmap);

    QBitmap transformed(ref const(QTransform) matrix) const;

    alias DataPtr = QExplicitlySharedDataPointer!(QPlatformPixmap);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QBitmap) +/

