private
{
    alias ushort Base;
    alias Base[] Genome;
    alias void function() Behavior;

    @safe Genome mutate(const Genome genome)
    {
        return genome.dup;
    }

    Behavior compileGenome(const Genome genome)
    {
        return null;
    }
}

class Organism
{
    const Behavior behavior;

    this(const Genome parent)
    {
        this.behavior = compileGenome(mutate(parent));
    }
}
