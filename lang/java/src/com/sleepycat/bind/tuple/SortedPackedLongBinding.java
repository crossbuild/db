/*-
 * See the file LICENSE for redistribution information.
 *
 * Copyright (c) 2000, 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 */

package com.sleepycat.bind.tuple;

import com.sleepycat.db.DatabaseEntry;
import com.sleepycat.util.PackedInteger;

/**
 * A concrete <code>TupleBinding</code> for a sorted <code>Long</code>
 * primitive wrapper or a sorted <code>long</code> primitive, that stores the
 * value in the smallest number of bytes possible.
 *
 * <p>There are two ways to use this class:</p>
 * <ol>
 * <li>When using the {@link com.sleepycat.db} package directly, the static
 * methods in this class can be used to convert between primitive values and
 * {@link DatabaseEntry} objects.</li>
 * <li>When using the {@link com.sleepycat.collections} package, an instance of
 * this class can be used with any stored collection.</li>
 * </ol>
 *
 * @see <a href="package-summary.html#integerFormats">Integer Formats</a>
 */
public class SortedPackedLongBinding extends TupleBinding<Long> {
    
    // javadoc is inherited
    public Long entryToObject(TupleInput input) {

        return input.readSortedPackedLong();
    }
    
    // javadoc is inherited
    public void objectToEntry(Long object, TupleOutput output) {

        output.writeSortedPackedLong(object);
    }
    
    // javadoc is inherited
    protected TupleOutput getTupleOutput(Long object) {

        return sizedOutput();
    }
    
    /**
     * Converts an entry buffer into a simple <code>Long</code> value.
     *
     * @param entry is the source entry buffer.
     *
     * @return the resulting value.
     */
    public static Long entryToLong(DatabaseEntry entry) {

        return entryToInput(entry).readSortedPackedLong();
    }
    
    /**
     * Converts a simple <code>Long</code> value into an entry buffer, using 
     * SortedPackedLong format.
     *
     * @param val is the source value.
     *
     * @param entry is the destination entry buffer.
     */
    public static void longToEntry(long val, DatabaseEntry entry) {

        outputToEntry(sizedOutput().writeSortedPackedLong(val), entry);
    }
    
    /**
     * Returns a tuple output object of the maximum size needed, to avoid
     * wasting space when a single primitive is output.
     */
    private static TupleOutput sizedOutput() {

        return new TupleOutput(new byte[PackedInteger.MAX_LONG_LENGTH]);
    }
}
