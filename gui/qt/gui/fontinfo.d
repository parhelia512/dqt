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
module qt.gui.fontinfo;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.font;
import qt.helpers;

/// Binding for C++ class [QFontInfo](https://doc.qt.io/qt-6/qfontinfo.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFontInfo
{
public:
    this(ref const(QFont) );
    @disable this(this);
    this(ref const(QFontInfo) );
    ~this();

    /+ref QFontInfo operator =(ref const(QFontInfo) );+/

    /+ void swap(QFontInfo &other) noexcept { d.swap(other.d); } +/

    QString family() const;
    QString styleName() const;
    int pixelSize() const;
    int pointSize() const;
    qreal pointSizeF() const;
    bool italic() const;
    QFont.Style style() const;
    int weight() const;
    pragma(inline, true) bool bold() const { return weight() > QFont.Weight.Normal; }
    bool underline() const;
    bool overline() const;
    bool strikeOut() const;
    bool fixedPitch() const;
    QFont.StyleHint styleHint() const;

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use weight() instead") +/ int legacyWeight() const;
/+ #endif +/

    bool exactMatch() const;

private:
    QExplicitlySharedDataPointer!(QFontPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QFontInfo) +/

