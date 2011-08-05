import std.file;
import std.stream;

import genome_parser;

void main()
{
    auto file = new BufferedFile("starting-genome.txt");
    assert(parseTextGenome(file) != null);
}
