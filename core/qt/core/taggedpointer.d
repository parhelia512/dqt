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
module qt.core.taggedpointer;
extern(C++):

import qt.config;
import qt.core.algorithms;
import qt.core.global;
import qt.core.math;
import qt.helpers;

extern(C++, "QtPrivate") {
    quint8 nextByteSize(quint8 bits) { return cast(quint8) ((bits + 7) / 8); }

    struct TagInfo(T)
    {
        extern(D) static immutable size_t alignment = T.alignof;
        static assert((alignment & (alignment - 1)) == 0,
            "Alignment of template parameter must be power of two");

        extern(D) static immutable quint8 tagBits = /+ QtPrivate:: +/qt.core.algorithms.qConstexprCountTrailingZeroBits(alignment);
        static assert(tagBits > 0,
            "Alignment of template parameter does not allow any tags");

        extern(D) static immutable size_t tagSize = /+ QtPrivate:: +/qt.core.math.qConstexprNextPowerOfTwo(cast(uint)nextByteSize(tagBits));
        static assert(tagSize < quintptr.sizeof,
            "Alignment of template parameter allows tags masking away pointer");

        alias TagType = QIntegerForSize!(tagSize).Unsigned;
    }
}

extern(C++, class) struct QTaggedPointer(T, Tag)
{
public:
    alias Type = T;
    alias TagType = Tag;

    static quintptr tagMask() { return TagInfo!(T).alignment - 1; }
    static quintptr pointerMask() { return ~tagMask(); }

    @disable this();
    /+this()/+ noexcept+/
    {
        this.d = 0;
    }+/
    this(typeof(null))/+ noexcept+/
    {
    }

    /+ explicit +/this(T* pointer, Tag tag = Tag())/+ noexcept+/
    {
        this.d = cast(quintptr)(pointer) | quintptr(tag);

        static assert((Type*).sizeof == QTaggedPointer.sizeof);

        (mixin(Q_ASSERT_X(q{(cast(quintptr)(pointer) & QTaggedPointer.tagMask()) == 0},q{ "QTaggedPointer<T, Tag>"},q{ "Pointer is not aligned"})));
        (mixin(Q_ASSERT_X(q{(static_cast!(/+ QtPrivate:: +/TagInfo!(T).TagType)(tag) & QTaggedPointer.pointerMask()) == 0},q{
            "QTaggedPointer<T, Tag>::setTag"},q{ "Tag is larger than allowed by number of available tag bits"})));
    }

    ref Type opUnary(string op)() const/+ noexcept+/ if (op == "*")
    {
        (mixin(Q_ASSERT(q{data()})));
        return *data();
    }

    /+Type* operator ->() const/+ noexcept+/
    {
        return data();
    }+/

    /+/+ explicit +/ auto opCast(T : bool)() const/+ noexcept+/
    {
        return !isNull();
    }+/

    /+ref QTaggedPointer operator =(T* other)/+ noexcept+/
    {
        d = reinterpret_cast!(quintptr)(other) | (d & tagMask());
        return this;
    }+/

    static Tag maximumTag()/+ noexcept+/
    {
        return cast(TagType)(cast(/+ typename +/ /+ QtPrivate:: +/TagInfo!(T).TagType)(tagMask()));
    }

    void setTag(Tag tag)
    {
        (mixin(Q_ASSERT_X(q{(static_cast!(/+ QtPrivate:: +/TagInfo!(T).TagType)(tag) & QTaggedPointer.pointerMask()) == 0},q{
            "QTaggedPointer<T, Tag>::setTag"},q{ "Tag is larger than allowed by number of available tag bits"})));

        d = (d & pointerMask()) | static_cast!(quintptr)(tag);
    }

    Tag tag() const/+ noexcept+/
    {
        return cast(TagType)(cast(/+ typename +/ /+ QtPrivate:: +/TagInfo!(T).TagType)(d & tagMask()));
    }

    T* data() const/+ noexcept+/
    {
        return reinterpret_cast!(T*)(d & pointerMask());
    }

    bool isNull() const/+ noexcept+/
    {
        return !data();
    }

    /+ void swap(QTaggedPointer &other) noexcept
    {
        std::swap(d, other.d);
    } +/

    /+ friend inline bool operator==(QTaggedPointer lhs, QTaggedPointer rhs) noexcept
    {
        return lhs.data() == rhs.data();
    } +/

    /+ friend inline bool operator!=(QTaggedPointer lhs, QTaggedPointer rhs) noexcept
    {
        return lhs.data() != rhs.data();
    } +/

    /+ friend inline bool operator==(QTaggedPointer lhs, std::nullptr_t) noexcept
    {
        return lhs.isNull();
    } +/

    /+ friend inline bool operator==(std::nullptr_t, QTaggedPointer rhs) noexcept
    {
        return rhs.isNull();
    } +/

    /+ friend inline bool operator!=(QTaggedPointer lhs, std::nullptr_t) noexcept
    {
        return !lhs.isNull();
    } +/

    /+ friend inline bool operator!=(std::nullptr_t, QTaggedPointer rhs) noexcept
    {
        return !rhs.isNull();
    } +/

    /+ friend inline bool operator!(QTaggedPointer ptr) noexcept
    {
        return !ptr.data();
    } +/

    /+ friend inline void swap(QTaggedPointer &p1, QTaggedPointer &p2) noexcept
    {
        p1.swap(p2);
    } +/

protected:
    quintptr d = 0;
}

/+ template <typename T, typename Tag>
constexpr inline std::size_t qHash(QTaggedPointer<T, Tag> p, std::size_t seed = 0) noexcept
{ return qHash(p.data(), seed); }

template <typename T, typename Tag>
class QTypeInfo<QTaggedPointer<T, Tag>>
    : public QTypeInfoMerger<QTaggedPointer<T, Tag>, quintptr> {}; +/

