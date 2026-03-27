import std.algorithm, std.traits;
import std.array;

// Workaround for https://issues.dlang.org/show_bug.cgi?id=18026
private bool simpleStartsWith(string a, string b)
{
    if(b.length > a.length)
        return false;
    return a[0..b.length] == b;
}

// The template parameter names have to match the real name for operator
// overloading to work around https://github.com/dlang/dmd/issues/22819.
template ApplyTemplateOpBinary(alias opBinary, P...)
{
    alias ApplyTemplateOpBinary = opBinary!P;
}
template ApplyTemplateOpOpAssign(alias opOpAssign, P...)
{
    alias ApplyTemplateOpOpAssign = opOpAssign!P;
}
template ApplyTemplateOpUnary(alias opUnary, P...)
{
    alias ApplyTemplateOpUnary = opUnary!P;
}

immutable binaryOperators = ["+", "-", "*", "/", "%", "^^", "&", "|", "^", "<<", ">>", ">>>", "~", "in"];
immutable unaryOperators = ["+", "-", "*", "~", "++", "--"];

// Accesses all functions in module m, so a wrong mangling will become a linker error.
size_t linkAll(alias m)()
{
    size_t sum;

    static foreach(s; __traits(allMembers, m))
    {{
        static if(is(__traits(getMember, m, s) == struct) || is(__traits(getMember, m, s) == union) || is(__traits(getMember, m, s) == class))
        {
            alias S = __traits(getMember, m, s);
            static if(__traits(getVisibility, __traits(getMember, m, s)) == "public")
            {{
                //pragma(msg, "=== ", s);
                static if(__traits(compiles, mixin("new m." ~ s)))
                    auto inst = mixin("new m." ~ s);
                else static if(is(__traits(getMember, m, s) == class))
                    mixin("m." ~ s ~ " inst;");
                else
                    mixin("m." ~ s ~ "* inst;");
                sum += cast(size_t)cast(void*)inst;
                static foreach(field; __traits(allMembers, S))
                {
                    static if(field != "qt_static_metacall" && field != "__postblit" && field != "qt_check_for_QGADGET_macro"
                            && !field.simpleStartsWith("dummyFunctionForChangingMangling"))
                    {
                        //pragma(msg, "   ", field);
                        static if(__traits(getOverloads, S, field).length == 0)
                        {
                            static if(__traits(compiles, &__traits(getMember, inst, field)))
                            {{
                                auto x = &__traits(getMember, inst, field);
                                sum += cast(size_t)cast(void*)x;
                            }}
                        }
                        static foreach(o; __traits(getOverloads, S, field))
                        {
                            //pragma(msg, "    ", typeof(o));
                            static if(__traits(isDisabled, o) || __traits(isAbstractFunction, o))
                            {
                            }
                            else static if(is(typeof(o) == function))
                            {
                                sum += cast(size_t)cast(void*)&o;
                            }
                            else
                            {{
                                auto x = &__traits(getMember, inst, field);
                                static if(is(typeof(x) == delegate))
                                    sum += cast(size_t)x.funcptr;
                                else
                                    sum += cast(size_t)cast(void*)x;
                            }}
                        }
                    }
                    static if (field == "opBinary")
                    {
                        static foreach(opBinary; __traits(getOverloads, S, field, true))
                        {
                            static foreach (op; binaryOperators)
                                static if (__traits(compiles, ApplyTemplateOpBinary!(opBinary, op)) && !__traits(isDisabled, ApplyTemplateOpBinary!(opBinary, op)))
                                {
                                    sum += cast(size_t)cast(void*)&ApplyTemplateOpBinary!(opBinary, op);
                                }
                        }
                    }
                    static if (field == "opOpAssign")
                    {
                        static foreach(opOpAssign; __traits(getOverloads, S, field, true))
                        {
                            static foreach (op; binaryOperators)
                                static if (__traits(compiles, ApplyTemplateOpOpAssign!(opOpAssign, op)) && !__traits(isDisabled, ApplyTemplateOpOpAssign!(opOpAssign, op)))
                                {
                                    sum += cast(size_t)cast(void*)&ApplyTemplateOpOpAssign!(opOpAssign, op);
                                }
                        }
                    }
                    static if (field == "opUnary")
                    {
                        static foreach(opUnary; __traits(getOverloads, S, field, true))
                        {
                            static foreach (op; unaryOperators)
                                static if (__traits(compiles, ApplyTemplateOpUnary!(opUnary, op)) && !__traits(isDisabled, ApplyTemplateOpUnary!(opUnary, op)))
                                {
                                    sum += cast(size_t)cast(void*)&ApplyTemplateOpUnary!(opUnary, op);
                                }
                        }
                    }
                }
            }}
        }
        // Don't link functions with extern(D) linkage, because alias to lambda does not work with separate compilation.
        static if(is(typeof(__traits(getMember, m, s)) == function) && __traits(getLinkage, __traits(getMember, m, s)) != "D"
            && !s.simpleStartsWith("dummyFunctionForChangingMangling"))
        {
            sum += cast(size_t)&__traits(getMember, m, s);
        }
    }}

    return sum;
}
