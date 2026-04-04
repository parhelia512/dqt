// QT_MODULES: core
// EXTRA_ARGS: -version=QT_NO_DEBUG
module testcore_nodebug;

import qt.config;
import qt.core.logging;
import qt.core.object;
import qt.core.string;
import qt.helpers;
import std.conv;

QtMsgType lastMsgType;
const(char)* lastMsgFile;
int lastMsgLine;
wstring lastMsg;
extern(C++) void testMessageHandler(QtMsgType type, ref const(QMessageLogContext) context, ref const(QString) msg)
{
    lastMsgType = type;
    lastMsgFile = context.file;
    lastMsgLine = context.line;
    lastMsg = msg.toConstWString.idup;
}

unittest
{
    auto prevHandler = qInstallMessageHandler(&testMessageHandler);
    scope(exit)
        qInstallMessageHandler(prevHandler);

    mixin(qDebug)("test1");
    assert(lastMsgType == QtMsgType.QtDebugMsg);
    assert(lastMsg == "test1");
    assert(lastMsgFile is null);
    assert(lastMsgLine == 0);

    mixin(qCritical)("test2");
    assert(lastMsgType == QtMsgType.QtCriticalMsg);
    assert(lastMsg == "test2");
    assert(lastMsgFile is null);
    assert(lastMsgLine == 0);

    mixin(qInfo)("test3");
    assert(lastMsgType == QtMsgType.QtInfoMsg);
    assert(lastMsg == "test3");
    assert(lastMsgFile is null);
    assert(lastMsgLine == 0);

    mixin(qWarning)("test4");
    assert(lastMsgType == QtMsgType.QtWarningMsg);
    assert(lastMsg == "test4");
    assert(lastMsgFile is null);
    assert(lastMsgLine == 0);

    if (false)
        mixin(qFatal)("test5");
}

unittest
{
    import qt.core.objectdefs;

    auto prevHandler = qInstallMessageHandler(&testMessageHandler);
    scope(exit)
        qInstallMessageHandler(prevHandler);

    scope test = new QObject;
    QObject.connect(test, mixin(SIGNAL(q{destroyed()})), test, mixin(SLOT(q{missingSlot(int)})));
    assert(lastMsg == wtext("QObject::connect: No such slot QObject::missingSlot(int)"));
    QObject.connect(test, mixin(SIGNAL(q{missingSignal(int)})), test, mixin(SLOT(q{deleteLater()})));
    assert(lastMsg == wtext("QObject::connect: No such signal QObject::missingSignal(int)"));
}
