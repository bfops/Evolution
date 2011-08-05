import std.algorithm;
import std.array;
import std.string;
import std.stdio;

import std_ext.container;

private
{
    alias ushort Base;
    alias Base[] Genome;
    alias void function() Behavior;

    // Look up bases based on lexical keywords.
    const Base[string] keywordLookup;
    // Look up keywords based on bases.
    const typeof(swapPairs(keywordLookup)) parsedLookup;

    @safe Genome mutate(const Genome genome)
    {
        return genome.dup;
    }

    Behavior compileGenome(const Genome genome)
    {
        return null;
    }
}

static this()
{
    keywordLookup = mapIncrementingValues!(string, Base)(
        //"spawn",
        "move",
        //"sense",
        //"eat",
        "if", "else", "loop",
        "equal", "greater", "less",
        "add", "subtract", "mul", "div", "mod",
        "lsh", "rsh", "or", "and", "xor", "not",
        "set", "get"
    );

    // TODO: Compile-time.
    assert(keywordLookup.keys.length < Base.max / 2);

    parsedLookup = swapPairs(keywordLookup);
}

bool isInt(Stream)(in Stream s)
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

long parseInt(Stream)(in Stream s)
{
    bool negate = false;
    long ret = 0;

    foreach(i, c; s)
    {
        if(i == 0 && c == '-')
        {
            negate = true;
            continue;
        }

        if(c >= '0' && c <= '9')
            ret = (10 * ret) + (c - '0');
    }

    if(negate)
        return -ret;

    return ret;
}

Genome parseTextGenome(Stream)(in Stream s, void function(Stream) output = &writeln!(Stream))
{
    Genome ret;
    auto commands = split(s.dup);

    foreach(command; commands)
    {
        if(command in keywordLookup)
            ret ~= keywordLookup[command];
        else if(isInt(command))
            long val = parseInt(command);
        else
        {
            output("Error parsing command \"" ~ command ~ "\".");
            return null;
        }
    }

    return ret;
}

string deparseGenome(in Genome genome);

class Organism
{
    const Behavior behavior;

    this(const Genome parent)
    {
        this.behavior = compileGenome(mutate(parent));
    }
}
