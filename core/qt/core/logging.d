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
module qt.core.logging;
extern(C++):

import qt.config;
import qt.core.string;
import qt.helpers;

/+ #ifndef QLOGGING_H +/
/+ #define QLOGGING_H

#if 0
// header is automatically included in qglobal.h
#pragma qt_no_master_include
#endif


/*
  Forward declarations only.

  In order to use the qDebug() stream, you must #include<QDebug>
*/
class QDebug; +/

enum QtMsgType { QtDebugMsg, QtWarningMsg, QtCriticalMsg, QtFatalMsg, QtInfoMsg, QtSystemMsg = QtMsgType.QtCriticalMsg }

/// Binding for C++ class [QMessageLogContext](https://doc.qt.io/qt-5/qmessagelogcontext.html).
extern(C++, class) struct QMessageLogContext
{
private:
    /+ Q_DISABLE_COPY(QMessageLogContext) +/
@disable this(this);
/+@disable this(ref const(QMessageLogContext));+/@disable ref QMessageLogContext opAssign(ref const(QMessageLogContext));public:
    /+ QMessageLogContext() noexcept = default; +/
    this(const(char)* fileName, int lineNumber, const(char)* functionName, const(char)* categoryName) nothrow
    {
        this.line = lineNumber;
        this.file = fileName;
        this.function_ = functionName;
        this.category = categoryName;
    }

    int version_ = 2;
    int line = 0;
    const(char)* file = null;
    const(char)* function_ = null;
    const(char)* category = null;

private:
    //ref QMessageLogContext copyContextFrom(ref const(QMessageLogContext) logContext) nothrow;

    /+ friend class QMessageLogger; +/
    /+ friend class QDebug; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QLoggingCategory;

/// Binding for C++ class [QMessageLogger](https://doc.qt.io/qt-5/qmessagelogger.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMessageLogger
{
private:
    /+ Q_DISABLE_COPY(QMessageLogger) +/
@disable this(this);
/+@disable this(ref const(QMessageLogger));+/@disable ref QMessageLogger opAssign(ref const(QMessageLogger));public:
    @disable this();
    /+this()
    {
        this.context = typeof(this.context)();
    }+/
    this(const(char)* file, int line, const(char)* function_)
    {
        this.context = typeof(this.context)(file, line, function_, "default");
    }
    this(const(char)* file, int line, const(char)* function_, const(char)* category)
    {
        this.context = typeof(this.context)(file, line, function_, category);
    }

    mixin(changeCppMangling(q{mangleChangeName("debug")}, q{
    void debug_(const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;
    }));
    void noDebug(const(char)* , ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/
    {}
    void info(const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void warning(const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void critical(const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;

    /+alias CategoryFunction = ExternCPPFunc!(ref const(QLoggingCategory) function());

    void debug_(ref const(QLoggingCategory) cat, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    void debug_(CategoryFunction catFunc, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    void info(ref const(QLoggingCategory) cat, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    void info(CategoryFunction catFunc, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void warning(ref const(QLoggingCategory) cat, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void warning(CategoryFunction catFunc, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void critical(ref const(QLoggingCategory) cat, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;
    /+ Q_DECL_COLD_FUNCTION +/
        void critical(CategoryFunction catFunc, const(char)* msg, ...) const /+ Q_ATTRIBUTE_FORMAT_PRINTF(3, 4) +/;+/

/+ #ifndef Q_CC_MSVC +/
    /+ Q_NORETURN +/
    /+ #endif
        Q_DECL_COLD_FUNCTION +/
        void fatal(const(char)* msg, ...) const nothrow /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;

/+ #ifndef QT_NO_DEBUG_STREAM
    QDebug debug() const;
    QDebug debug(const QLoggingCategory &cat) const;
    QDebug debug(CategoryFunction catFunc) const;
    QDebug info() const;
    QDebug info(const QLoggingCategory &cat) const;
    QDebug info(CategoryFunction catFunc) const;
    QDebug warning() const;
    QDebug warning(const QLoggingCategory &cat) const;
    QDebug warning(CategoryFunction catFunc) const;
    QDebug critical() const;
    QDebug critical(const QLoggingCategory &cat) const;
    QDebug critical(CategoryFunction catFunc) const;

    QNoDebug noDebug() const noexcept;
#endif +/ // QT_NO_DEBUG_STREAM

private:
    QMessageLogContext context /* = TODO*/;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if !defined(QT_MESSAGELOGCONTEXT) && !defined(QT_NO_MESSAGELOGCONTEXT)
#  if defined(QT_NO_DEBUG)
#    define QT_NO_MESSAGELOGCONTEXT
#  else
#    define QT_MESSAGELOGCONTEXT
#  endif
#endif +/

version (QT_NO_DEBUG) {} else
{
  /+ #define QT_MESSAGELOG_FILE static_cast<const char *>(__FILE__) +/
enum QT_MESSAGELOG_FILE = q{static_cast!(const(char)*)(__FILE__)};
  /+ #define QT_MESSAGELOG_LINE __LINE__ +/
enum QT_MESSAGELOG_LINE = q{__LINE__};
  /+ #define QT_MESSAGELOG_FUNC static_cast<const char *>(Q_FUNC_INFO) +/
enum QT_MESSAGELOG_FUNC = q{static_cast!(const(char)*)(__FUNCTION__)};
}
version (QT_NO_DEBUG)
{
  /+ #define QT_MESSAGELOG_FILE nullptr +/
enum QT_MESSAGELOG_FILE = q{null};
  /+ #define QT_MESSAGELOG_LINE 0 +/
enum QT_MESSAGELOG_LINE = q{0};
  /+ #define QT_MESSAGELOG_FUNC nullptr +/
enum QT_MESSAGELOG_FUNC = q{null};
}

/+ #define qDebug QMessageLogger(QT_MESSAGELOG_FILE, QT_MESSAGELOG_LINE, QT_MESSAGELOG_FUNC).debug +/
enum qDebug = mixin(interpolateMixin(q{dqtimported!q{qt.core.logging}.QMessageLogger($(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FILE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_LINE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FUNC)).debug_}));
/+ #define qInfo QMessageLogger(QT_MESSAGELOG_FILE, QT_MESSAGELOG_LINE, QT_MESSAGELOG_FUNC).info +/
enum qInfo = mixin(interpolateMixin(q{dqtimported!q{qt.core.logging}.QMessageLogger($(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FILE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_LINE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FUNC)).info}));
/+ #define qWarning QMessageLogger(QT_MESSAGELOG_FILE, QT_MESSAGELOG_LINE, QT_MESSAGELOG_FUNC).warning +/
enum qWarning = mixin(interpolateMixin(q{dqtimported!q{qt.core.logging}.QMessageLogger($(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FILE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_LINE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FUNC)).warning}));
/+ #define qCritical QMessageLogger(QT_MESSAGELOG_FILE, QT_MESSAGELOG_LINE, QT_MESSAGELOG_FUNC).critical +/
enum qCritical = mixin(interpolateMixin(q{dqtimported!q{qt.core.logging}.QMessageLogger($(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FILE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_LINE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FUNC)).critical}));
/+ #define qFatal QMessageLogger(QT_MESSAGELOG_FILE, QT_MESSAGELOG_LINE, QT_MESSAGELOG_FUNC).fatal +/
enum qFatal = mixin(interpolateMixin(q{dqtimported!q{qt.core.logging}.QMessageLogger($(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FILE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_LINE), }
            ~ q{$(dqtimported!q{qt.core.logging}.QT_MESSAGELOG_FUNC)).fatal}));

/+ #define QT_NO_QDEBUG_MACRO while (false) QMessageLogger().noDebug

#if defined(QT_NO_DEBUG_OUTPUT)
#  undef qDebug
#  define qDebug QT_NO_QDEBUG_MACRO
#endif
#if defined(QT_NO_INFO_OUTPUT)
#  undef qInfo
#  define qInfo QT_NO_QDEBUG_MACRO
#endif
#if defined(QT_NO_WARNING_OUTPUT)
#  undef qWarning
#  define qWarning QT_NO_QDEBUG_MACRO
#endif +/

/+ Q_CORE_EXPORT +/ void qt_message_output(QtMsgType, ref const(QMessageLogContext) context,
                                     ref const(QString) message);

/+ Q_CORE_EXPORT +/ /+ Q_DECL_COLD_FUNCTION +/ void qErrnoWarning(int code, const(char)* msg, ...);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_COLD_FUNCTION +/ void qErrnoWarning(const(char)* msg, ...);

/+ #if QT_DEPRECATED_SINCE(5, 0)// deprecated. Use qInstallMessageHandler instead!
typedef void (*QtMsgHandler)(QtMsgType, const char *);
Q_CORE_EXPORT QT_DEPRECATED QtMsgHandler qInstallMsgHandler(QtMsgHandler);
#endif +/

alias QtMessageHandler = ExternCPPFunc!(void function(QtMsgType, ref const(QMessageLogContext) , ref const(QString) ));
/+ Q_CORE_EXPORT +/ QtMessageHandler qInstallMessageHandler(QtMessageHandler);

/+ Q_CORE_EXPORT +/ void qSetMessagePattern(ref const(QString) messagePattern);
/+ Q_CORE_EXPORT +/ QString qFormatLogMessage(QtMsgType type, ref const(QMessageLogContext) context,
                                        ref const(QString) buf);

/+ #endif +/ // QLOGGING_H

