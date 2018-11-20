"""
Opis:
Funkcja oblicza pierwiastki funkcji używając metody siecznych.

Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
x0,x1 – przybliżenia początkowe,
delta,epsilon – dokładności obliczeń,
maxit – maksymalna dopuszczalna liczba iteracji,

Wyniki:
(r,v,it,err) – czwórka, gdzie
r – przybliżenie pierwiastka równania f(x) = 0,
v – wartość f(r)
it – liczba wykonanych iteracji,
err – sygnalizacja błędu
    0 - metoda zbieżna
    1 - nie osiągnięto wymaganej dokładności w maxit iteracji
"""
function msiecznych(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fa = f(a)
    fb = f(b)
    for k in 1:maxit
        if abs(fa) > abs(fb)
            tmp = a
            a = b
            b = tmp
            tmp = fa
            fa = fb
            fb = tmp
        end
        s = (b - a) / (fb - fa)
        b = a
        fb = fa
        a = a - fa * s
        fa = f(a)
        if abs(b - a) < delta || abs(fa) < epsilon
            return (a, fa, k, 0)
        end
    end
    return (a, fa, k, 1)
end
