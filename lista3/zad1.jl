#author Adrian Mucha
"""
Opis:
Funkcja oblicza pierwiastki funkcji używając metody bisekcji.

Dane:
f – funkcja f(x) zadana jako anonimowa funkcja (ang. anonymous function),
a,b – końce przedziału początkowego,
delta,epsilon – dokładności obliczeń,

Wyniki:
(r,v,it,err) – czwórka, gdzie
r – przybliżenie pierwiastka równania f(x) = 0,
v – wartość f(r),
it – liczba wykonanych iteracji,
err – sygnalizacja błędu
    0 - brak błędu
    1 - funkcja nie zmienia znaku w przedziale [a,b]
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    it = 0
    u = f(a)
    v = f(b)
    e = b - a
    if sign(u) == sign(v)
        return (0, 0, 0, 1)
    end
    while true
        it += 1
        e = e/2
        c = a + e
        w = f(c)
        if abs(e) < delta || abs(w) < epsilon
            return (c, w, it, 0)
        end
        if sign(w) != sign(u)
            b = c
            v = w
        else
            a = c
            u = w
        end
    end
end
