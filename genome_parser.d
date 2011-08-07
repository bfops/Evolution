import std.array;
import std.stdio;
import std.stream;

import std_ext.container;

import ecosystem;

private
{
    // Look up bases based on lexical keywords.
    const Base[string] keywordLookup;
    // Look up keywords based on bases.
    const typeof(swapPairs(keywordLookup)) parsedLookup;

    bool isInt(Char)(in Char[] s)
    {
        foreach(i, c; s)
        {
            if(i == 0 && c == '-')
                continue;
            if((c < '0' || c > '9') && c != ',')
                return false;
        }

        return true;
    }

    // TODO: Fix overflow.
    Base parseInt(Char)(in Char[] s)
    {
        // Sanity check to make sure that returning negative unsigned values won't be strange.
        static assert(cast(Base)-1 == ~cast(Base)0);

        bool negate = false;
        Base ret = 0;

        foreach(i, c; s)
        {
            if(i == 0 && c == '-')
            {
                negate = true;
                continue;
            }

            if(c >= '0' && c <= '9')
                ret = cast(Base)((10 * ret) + (c - '0'));
        }

        if(negate)
            return -ret;

        return ret;
    }
}

static this()
{
    keywordLookup = mapIncrementingValues!(string, Base)(
        //"spawn",
        "move",
        //"sense",
        //"eat",
        "if", "else", "elif", "end", //"loop",
        "equal", "greater", "less",
        "add", "subtract", "mul", "div", "mod",
        "lsh", "rsh", "or", "and", "xor", "not",
        "set", "get"
    );

    // TODO: Compile-time.
    assert(keywordLookup.keys.length < Base.max / 2);

    parsedLookup = swapPairs(keywordLookup);
}

Genome parseTextGenome(alias output = writeln, StreamType : InputStream)(StreamType commands)
{
    static void keywordError(const char[] keyword, ulong lineNumber)
    {
        output("Keyword error: \"%s\", line %u.", keyword, lineNumber);
    }

    static void overflowError(Base val, ulong lineNumber)
    {
        output("Overflow error: %d, line %u.", val, lineNumber);
    }

    Genome ret;

    foreach(ulong lineNumber, char[] line; commands)
    {
        auto words = split(line);

        foreach(keyword; words)
        {
            if(isInt(keyword))
            {
                Base val = parseInt(keyword);
                // Overflow check.
                if(Base.max - keywordLookup.keys.length < val)
                {
                    overflowError(val, lineNumber);
                    return null;
                }

                ret ~= cast(Base)(val + keywordLookup.keys.length);
            }
            else if(keyword in keywordLookup)
            {
                ret ~= keywordLookup[keyword];
            }
            else
            {
                keywordError(keyword, lineNumber);
                return null;
            }
        }
    }

    return ret;
}

string deparseGenome(in Genome genome);
