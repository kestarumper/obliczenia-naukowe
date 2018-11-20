push!(LOAD_PATH, ".")
using RootsModule

f1(x) = exp(1 - x) - 1
f2(x) = x*exp(-x)
δ = 10.0^(-5)
ϵ = 10.0^(-5)
MAXIT = 1024

function test_bisekcji()
    print("Bisekcja\t")
    a = -5.0
    b = 5.0
    result = (
        RootsModule.mbisekcji(f1, a, b, δ, ϵ),
        RootsModule.mbisekcji(f2, a, b, δ, ϵ)
    )
    println(result)
end

function test_newton()
    print("Newton\t\t")
    pf1(x) = -exp(1 - x)
    pf2(x) = -exp(-x)*(x - 1)
    x0 = -1.0
    result = (
        RootsModule.mstycznych(f1, pf1, x0, δ, ϵ, MAXIT),
        RootsModule.mstycznych(f2, pf2, x0, δ, ϵ, MAXIT)
    )
    println(result)
end

function test_siecznych()
    print("Sieczne\t\t")
    x0 = -2.0
    x1 = -1.0
    result = (
        RootsModule.msiecznych(f1, x0, x1, δ, ϵ, MAXIT),
        RootsModule.msiecznych(f2, x0, x1, δ, ϵ, MAXIT)
    )
    println(result)
end

function test_changed_newton()
    print("ChgnNwtn\t\t")
    pf1(x) = -exp(1 - x)
    pf2(x) = -exp(-x)*(x - 1)
    result = (
        RootsModule.mstycznych(f1, pf1, 10.0, δ, ϵ, MAXIT),
        RootsModule.mstycznych(f2, pf2, 196.0, δ, ϵ, MAXIT),
        RootsModule.mstycznych(f2, pf2, 1.0, δ, ϵ, MAXIT),
    )
    println(result)
end

test_bisekcji()
test_newton()
test_siecznych()
test_changed_newton()
println("")
