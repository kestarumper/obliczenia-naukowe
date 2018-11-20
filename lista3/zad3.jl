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
