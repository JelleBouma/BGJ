package scribblevercors.util;

import java.util.Arrays;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class ArrayList<E> extends java.util.ArrayList<E> {

    public ArrayList(E... varargs) {
        super();
        addAll(varargs);
    }

    public void addAll(E... varargs) {
        addAll(Arrays.asList(varargs));
    }

    /**
     * A filter which does not modify this list, but returns a new list where each element is the result of a specified function.
     * The element at index x (ranged from 0 to list size - 1) in the returned list will be the result of the convertor function applied on element x in this list.
     * @param convertor The convertor function which will be applied on each element in this list.
     * @param <T> The return type, can be any type.
     * @return A new list where each element is converted.
     */
    public <T> ArrayList<T> convertAll(Function<E, T> convertor) {
        return stream().map(convertor).collect(Collectors.toCollection(ArrayList<T>::new));
    }

    /**
     * A filter which does not modify this list.
     * @param predicate the predicate to check.
     * @return a new list with only the elements for which the predicate is true.
     */
    public ArrayList<E> filter(Predicate<E> predicate) {
        ArrayList<E> res = new ArrayList<>();
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

    /**
     * Get the first element from the list without changing the list.
     * @return the first element in this list.
     */
    public E first() {
        return get(0);
    }

    /**
     * Get the last element from the list without changing the list.
     * @return the last element in this list.
     */
    public E last() {
        return get(size() - 1);
    }
}
