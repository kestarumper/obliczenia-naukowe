push!(LOAD_PATH, ".")
using RootsModule

fsin(x) = sin(x) - (0.5x)^2
δ = 0.5*10.0^(-5)
ϵ = 0.5*10.0^(-5)
MAXIT = 1024

function test_bisect()
    a = 1.5
    b = 2.0
    result = RootsModule.mbisekcji(fsin, a, b, δ, ϵ)
    println("Metoda Bisekcji:\t$result")
end

function test_newton()
    x0 = 1.5
    pf(x) = cos(x) - 0.5x
    result = RootsModule.mstycznych(fsin, pf, x0, δ, ϵ, MAXIT)
    println("Metoda Stycznych:\t$result")
end

function test_siecznych()
    x0 = 1.0
    x1 = 2.0
    result = RootsModule.msiecznych(fsin, x0, x1, δ, ϵ, MAXIT)
    println("Metoda Siecznych:\t$result")
end

test_bisect()
test_newton()
test_siecznych()
