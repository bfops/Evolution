import std.file;

import ecosystem;

void main()
{
    assert(parseTextGenome(cast(char[])read("starting-genome.txt")) != null);
}
