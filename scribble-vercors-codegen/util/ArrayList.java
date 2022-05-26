package scribblevercors.util;

import java.util.Arrays;
import java.util.function.Function;
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
}
