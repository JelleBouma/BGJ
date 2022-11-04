package scribblevercors.util;

import java.util.Arrays;
import java.util.Collection;
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
     * @param predicate The predicate to check for.
     * @return An element for which the predicate evaluates to true.
     * If the predicate is true for no element, null is returned instead.
     */
    public E getMatch(Predicate<E> predicate) {
        for (E e : this)
            if (predicate.test(e))
                return e;
        return null;
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

    /**
     * Checks if any element from the input is present in this HashSet.
     * @return true if there is an element in the input collection which is equal to an element in this HashSet.
     */
    public boolean containsAny(Collection<E> collection) {
        for (E e : collection)
            if (contains(e))
                return true;
        return false;
    }
}