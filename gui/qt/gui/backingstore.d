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
module qt.gui.backingstore;
extern(C++):

import qt.config;
import qt.core.point;
import qt.core.scopedpointer;
import qt.core.size;
import qt.gui.paintdevice;
import qt.gui.region;
import qt.gui.window;
import qt.helpers;

extern(C++, class) struct QBackingStorePrivate;
extern(C++, class) struct QPlatformBackingStore;

/// Binding for C++ class [QBackingStore](https://doc.qt.io/qt-5/qbackingstore.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QBackingStore
{
public:
    /+ explicit +/this(QWindow window);
    ~this();

    QWindow window() const;

    QPaintDevice paintDevice();

    void flush(ref const(QRegion) region, QWindow window = null, ref const(QPoint) offset = globalInitVar!QPoint);

    void resize(ref const(QSize) size);
    QSize size() const;

    bool scroll(ref const(QRegion) area, int dx, int dy);

    void beginPaint(ref const(QRegion) );
    void endPaint();

    void setStaticContents(ref const(QRegion) region);
    QRegion staticContents() const;
    bool hasStaticContents() const;

    QPlatformBackingStore* handle() const;

private:
    QScopedPointer!(QBackingStorePrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

