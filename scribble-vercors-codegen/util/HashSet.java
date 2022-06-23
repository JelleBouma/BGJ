package scribblevercors.util;

import java.util.Arrays;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class HashSet<E> extends java.util.HashSet<E> {

    public HashSet(E... varargs) {
        super();
        addAll(varargs);
    }

    public void addAll(E... varargs) {
        addAll(Arrays.asList(varargs));
    }

    /**
     * A filter which does not modify this set, but returns a new set where each element is the result of a specified function.
     * @param convertor The convertor function which will be applied on each element in this set.
     * @param <T> The return type, can be any type.
     * @return A new set where each element is converted.
     */
    public <T> HashSet<T> convertAll(Function<E, T> convertor) {
        return stream().map(convertor).collect(Collectors.toCollection(HashSet<T>::new));
    }

    /**
     * A filter which does not modify this set.
     * @param predicate the predicate to check.
     * @return a new set with only the elements for which the predicate is true.
     */
    public HashSet<E> filter(Predicate<E> predicate) {
        HashSet<E> res = new HashSet<>();
        for (E e : this)
            if (predicate.test(e))
                res.add(e);
        return res;
    }

    /**
     * Checks if any element returns true for the predicate.
     * @param predicate the predicate to check.
     * @return true if there is an element that returns true for the predicate, false otherwise.
     */
    public boolean anyMatch(Predicate<E> predicate) {
        for (E e : this)
            if (predicate.test(e))
                return true;
        return false;
    }
}