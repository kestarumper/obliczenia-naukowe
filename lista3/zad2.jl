#author Adrian Mucha
"""
# Opis:
Funkcja oblicza pierwiastki funkcji używając metody stycznych.

# Dane:
* f, pf – funkcją f(x) oraz pochodną f'(x) zadane jako anonimowe funkcje,
* x0 – przybliżenie początkowe,
* delta,epsilon – dokładności obliczeń,
* maxit – maksymalna dopuszczalna liczba iteracji,

# Wyniki:
* (r,v,it,err) – czwórka, gdzie
* r – przybliżenie pierwiastka równania f(x) = 0,
* v – wartość f(r),
* it – liczba wykonanych iteracji,
* err – sygnalizacja błędu
    * 0 - metoda zbieżna
    * 1 - nie osiągnięto wymaganej dokładności w maxit iteracji,
    * 2 - pochodna bliska zeru
"""
function mstycznych(f,pf,x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    if abs(v) < epsilon
        return (x0, v, 0, 1)
    end
    for k in 1:maxit
        x1 = x0 - v / pf(x0)
        v = f(x1)
        if abs(x1 - x0) < delta || abs(v) < epsilon
            return (x1, v, k, 0)
        end
        x0 = x1
    end
    return (x0, v, maxit, 1)
end
