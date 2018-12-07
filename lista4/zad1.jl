"""
# Dane
    x - wektor długości n+1 zawierający węzły x0,...,xn
        x[1] = x0,...,x[n+1] = xn
    f - wektor długości n+1 zawierający wartości interpolowanej
        funkcji w węzłach f(x0),...,f(xn)
# Wynik
    fx - wektor długości n+1 zawierający obliczone ilorazy różnicowe
         fx[1]=f[x0],
         fx[2]=f[x0,x1], fx[n]=f[x0,...,xn-1], fx[n+1]=f[x0,...,xn]
"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    n = length(x)
    d = [fi for fi in f]
    if length(f) != n
        return error("Vector lengths are not equal.")
    end
    for j in 1:n
        for i in n:-1:j+1
            di = d[i]
            di_1 = d[i-1]
            xi = x[i]
            xij = x[i-j]
            d[i] = (di - di_1) / (xi - xij)
        end
    end
    return d
end
