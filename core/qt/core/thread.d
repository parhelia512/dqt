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
module qt.core.thread;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.deadlinetimer;
import qt.core.namespace;
import qt.core.object;
import qt.helpers;

// For QThread::create
/+ #if QT_CONFIG(cxx11_future)
#endif
// internal compiler error with mingw 8.1
#if defined(Q_CC_MSVC) && defined(Q_PROCESSOR_X86)
#endif +/



extern(C++, class) struct QThreadData;
extern(C++, class) struct QThreadPrivate;

/// Binding for C++ class [QThread](https://doc.qt.io/qt-6/qthread.html).
class /+ Q_CORE_EXPORT +/ QThread : QObject
{
    mixin(Q_OBJECT);
public:
    /+ static Qt::HANDLE currentThreadId() noexcept Q_DECL_PURE_FUNCTION; +/
    static QThread currentThread();
    static int idealThreadCount()/+ noexcept+/;
    static void yieldCurrentThread();

    /+ explicit +/this(QObject parent = null);
    ~this();

    enum Priority {
        IdlePriority,

        LowestPriority,
        LowPriority,
        NormalPriority,
        HighPriority,
        HighestPriority,

        TimeCriticalPriority,

        InheritPriority
    }

    final void setPriority(Priority priority);
    final Priority priority() const;

    final bool isFinished() const;
    final bool isRunning() const;

    final void requestInterruption();
    final bool isInterruptionRequested() const;

    final void setStackSize(uint stackSize);
    final uint stackSize() const;

    final QAbstractEventDispatcher* eventDispatcher() const;
    final void setEventDispatcher(QAbstractEventDispatcher* eventDispatcher);

    override bool event(QEvent event);
    final int loopLevel() const;

/+ #if QT_CONFIG(cxx11_future) || defined(Q_CLANG_QDOC) +/
    /+ template <typename Function, typename... Args> +/
    /+ [[nodiscard]] static QThread *create(Function &&f, Args &&... args); +/
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void start(Priority = Priority.InheritPriority);
    @QSlot final void terminate();
    @QSlot final void exit(int retcode = 0);
    @QSlot final void quit();

public:
    final bool wait(QDeadlineTimer deadline = QDeadlineTimer(QDeadlineTimer.ForeverConstant.Forever));
/+    final bool wait(cpp_ulong  time)
    {
        version (Android)
            import qt.core.global;
        version (Android) {} else
            import core.stdc.time;

        if (time == (/+ std:: +/numeric_limits!(cpp_ulong).max)())
            return wait(QDeadlineTimer(QDeadlineTimer.ForeverConstant.Forever));
        return wait(QDeadlineTimer(cast(Identity!(mixin((true)?q{duration!(Rep, Period)}:q{qint64}))) (time)));
    }+/

    static void sleep(cpp_ulong );
    static void msleep(cpp_ulong );
    static void usleep(cpp_ulong );

/+ Q_SIGNALS +/public:
    @QSignal final void started(QPrivateSignal);
    @QSignal final void finished(QPrivateSignal);

protected:
    /+ virtual +/ void run();
    final int exec();

    static void setTerminationEnabled(bool enabled = true);

protected:
    this(ref QThreadPrivate dd, QObject parent = null);

private:
    /+ Q_DECLARE_PRIVATE(QThread) +/

/+ #if QT_CONFIG(cxx11_future) +/
    /+ [[nodiscard]] static QThread *createThreadImpl(std::future<void> &&future); +/
/+ #endif +/
    static /+ Qt:: +/qt.core.namespace.HANDLE currentThreadIdImpl()/+ noexcept /+ Q_DECL_PURE_FUNCTION +/__attribute__((pure))+/;

    /+ friend class QCoreApplication; +/
    /+ friend class QThreadData; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(cxx11_future)
template <typename Function, typename... Args>
QThread *QThread::create(Function &&f, Args &&... args)
{
    using DecayedFunction = typename std::decay<Function>::type;
    auto threadFunction =
        [f = static_cast<DecayedFunction>(std::forward<Function>(f))](auto &&... largs) mutable -> void
        {
            (void)std::invoke(std::move(f), std::forward<decltype(largs)>(largs)...);
        };

    return createThreadImpl(std::async(std::launch::deferred,
                                       std::move(threadFunction),
                                       std::forward<Args>(args)...));
}
#endif // QT_CONFIG(cxx11_future)

/*
    On architectures and platforms we know, interpret the thread control
    block (TCB) as a unique identifier for a thread within a process. Otherwise,
    fall back to a slower but safe implementation.

    As per the documentation of currentThreadId, we return an opaque handle
    as a thread identifier, and application code is not supposed to use that
    value for anything. In Qt we use the handle to check if threads are identical,
    for which the TCB is sufficient.

    So we use the fastest possible way, rather than spend time on returning
    some pseudo-interoperable value.
*/
inline Qt::HANDLE QThread::currentThreadId() noexcept
{
    // define is undefed if we have to fall back to currentThreadIdImpl
#define QT_HAS_FAST_CURRENT_THREAD_ID
    Qt::HANDLE tid; // typedef to void*
    static_assert(sizeof(tid) == sizeof(void*));
    // See https://akkadia.org/drepper/tls.pdf for x86 ABI
#if defined(Q_PROCESSOR_X86_32) && defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID) // x86 32-bit always uses GS
    __asm__("movl %%gs:0, %0" : "=r" (tid) : : );
#elif defined(Q_PROCESSOR_X86_64) && defined(Q_OS_DARWIN64)
    // 64bit macOS uses GS, see https://github.com/apple/darwin-xnu/blob/master/libsyscall/os/tsd.h
    __asm__("movq %%gs:0, %0" : "=r" (tid) : : );
#elif defined(Q_PROCESSOR_X86_64) && (defined(Q_OS_LINUX) || defined(Q_OS_FREEBSD)) && !defined(Q_OS_ANDROID)
    // x86_64 Linux, BSD uses FS
    __asm__("movq %%fs:0, %0" : "=r" (tid) : : );
#elif defined(Q_PROCESSOR_X86_64) && defined(Q_OS_WIN)
    // See https://en.wikipedia.org/wiki/Win32_Thread_Information_Block
    // First get the pointer to the TIB
    quint8 *tib;
# if defined(Q_CC_MINGW) // internal compiler error when using the intrinsics
    __asm__("movq %%gs:0x30, %0" : "=r" (tib) : :);
# else
    tib = reinterpret_cast<quint8 *>(__readgsqword(0x30));
# endif
    // Then read the thread ID
    tid = *reinterpret_cast<Qt::HANDLE *>(tib + 0x48);
#elif defined(Q_PROCESSOR_X86_32) && defined(Q_OS_WIN)
    // First get the pointer to the TIB
    quint8 *tib;
# if defined(Q_CC_MINGW) // internal compiler error when using the intrinsics
    __asm__("movl %%fs:0x18, %0" : "=r" (tib) : :);
# else
    tib = reinterpret_cast<quint8 *>(__readfsdword(0x18));
# endif
    // Then read the thread ID
    tid = *reinterpret_cast<Qt::HANDLE *>(tib + 0x24);
#else
#undef QT_HAS_FAST_CURRENT_THREAD_ID
    tid = currentThreadIdImpl();
#endif
    return tid;
} +/

