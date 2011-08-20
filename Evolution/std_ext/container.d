/**
 * Creates an associative array with keys `keys`, and incrementing values, starting at `U.init`.
 *
 * Returns: An associative array with keys `keys`, and incremented values.
 *
 * Notes: If there are duplicate values in `keys`, then some values will be skipped in the array.
 */
pure U[T] mapIncrementingValues(T, U)(in T[] keys...)
{
    typeof(return) ret;

    U val;
    foreach(key; keys)
    {
        ret[key] = val;
        ++val;
    }

    return ret;
}

/**
 * Swaps the keys and values of an associative array.
 *
 * Params:
 *      map = The associative array of which to swap keys and values.
 *
 * Returns: A copy of `map`, with keys and values swapped.
 *
 * Notes: If multiple identical values exist, all but the last will be eliminated from the returned array.
 */
typeof(T.keys[0])[typeof(T.values[0])] swapPairs(T)(in T map)
{
    typeof(return) ret;

    foreach(key, val; map)
        ret[val] = key;

    return ret;
}
