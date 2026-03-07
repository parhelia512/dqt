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
module qt.gui.surfaceformat;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.metamacros;
import qt.core.pair;
import qt.helpers;

extern(C++, class) struct QOpenGLContext;
extern(C++, class) struct QSurfaceFormatPrivate;

/// Binding for C++ class [QSurfaceFormat](https://doc.qt.io/qt-5/qsurfaceformat.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QSurfaceFormat
{
    mixin(Q_GADGET);
public:
    enum FormatOption {
        StereoBuffers            = 0x0001,
        DebugContext             = 0x0002,
        DeprecatedFunctions      = 0x0004,
        ResetNotification        = 0x0008
    }
    /+ Q_ENUM(FormatOption) +/
    /+ Q_DECLARE_FLAGS(FormatOptions, FormatOption) +/
alias FormatOptions = QFlags!(FormatOption);
    enum SwapBehavior {
        DefaultSwapBehavior,
        SingleBuffer,
        DoubleBuffer,
        TripleBuffer
    }
    /+ Q_ENUM(SwapBehavior) +/

    enum RenderableType {
        DefaultRenderableType = 0x0,
        OpenGL                = 0x1,
        OpenGLES              = 0x2,
        OpenVG                = 0x4
    }
    /+ Q_ENUM(RenderableType) +/

    enum OpenGLContextProfile {
        NoProfile,
        CoreProfile,
        CompatibilityProfile
    }
    /+ Q_ENUM(OpenGLContextProfile) +/

    enum ColorSpace {
        DefaultColorSpace,
        sRGBColorSpace
    }
    /+ Q_ENUM(ColorSpace) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /*implicit*/ this(FormatOptions options);
    @disable this(this);
    this(ref const(QSurfaceFormat) other);
    ref QSurfaceFormat opAssign(ref const(QSurfaceFormat) other);
    ~this();

    void setDepthBufferSize(int size);
    int depthBufferSize() const;

    void setStencilBufferSize(int size);
    int stencilBufferSize() const;

    void setRedBufferSize(int size);
    int redBufferSize() const;
    void setGreenBufferSize(int size);
    int greenBufferSize() const;
    void setBlueBufferSize(int size);
    int blueBufferSize() const;
    void setAlphaBufferSize(int size);
    int alphaBufferSize() const;

    void setSamples(int numSamples);
    int samples() const;

    void setSwapBehavior(SwapBehavior behavior);
    SwapBehavior swapBehavior() const;

    bool hasAlpha() const;

    void setProfile(OpenGLContextProfile profile);
    OpenGLContextProfile profile() const;

    void setRenderableType(RenderableType type);
    RenderableType renderableType() const;

    void setMajorVersion(int majorVersion);
    int majorVersion() const;

    void setMinorVersion(int minorVersion);
    int minorVersion() const;

    mixin(changeCppMangling(q{mangleChangeName("version")}, q{
    QPair!(int, int) version_() const;
    }));
    void setVersion(int major, int minor);

    pragma(inline, true) bool stereo() const
    {
        return testOption(QSurfaceFormat.FormatOption.StereoBuffers);
    }
    void setStereo(bool enable);

/+ #if QT_DEPRECATED_SINCE(5, 2) +/
    /+ QT_DEPRECATED +/ void setOption(FormatOptions opt);
    /+ QT_DEPRECATED +/ bool testOption(FormatOptions opt) const;
/+ #endif +/

    void setOptions(FormatOptions options);
    void setOption(FormatOption option, bool on = true);
    bool testOption(FormatOption option) const;
    FormatOptions options() const;

    int swapInterval() const;
    void setSwapInterval(int interval);

    ColorSpace colorSpace() const;
    void setColorSpace(ColorSpace colorSpace);

    static void setDefaultFormat(ref const(QSurfaceFormat) format);
    static QSurfaceFormat defaultFormat();

private:
    QSurfaceFormatPrivate* d;

    void detach();

    /+ friend Q_GUI_EXPORT bool operator==(const QSurfaceFormat&, const QSurfaceFormat&); +/
    /+ friend Q_GUI_EXPORT bool operator!=(const QSurfaceFormat&, const QSurfaceFormat&); +/
/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_GUI_EXPORT QDebug operator<<(QDebug, const QSurfaceFormat &);
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+/+ Q_GUI_EXPORT +/ bool operator ==(ref const(QSurfaceFormat), ref const(QSurfaceFormat));+/
/+/+ Q_GUI_EXPORT +/ bool operator !=(ref const(QSurfaceFormat), ref const(QSurfaceFormat));+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QSurfaceFormat &);
#endif +/
/+pragma(inline, true) QFlags!(QSurfaceFormat.FormatOptions.enum_type) operator |(QSurfaceFormat.FormatOptions.enum_type f1, QSurfaceFormat.FormatOptions.enum_type f2)nothrow{return QFlags!(QSurfaceFormat.FormatOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QSurfaceFormat.FormatOptions.enum_type) operator |(QSurfaceFormat.FormatOptions.enum_type f1, QFlags!(QSurfaceFormat.FormatOptions.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QSurfaceFormat.FormatOptions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QSurfaceFormat::FormatOptions) +/
