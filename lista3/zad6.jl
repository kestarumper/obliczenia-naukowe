push!(LOAD_PATH, ".")
using RootsModule

f1(x) = exp(1 - x) - 1
f2(x) = x*exp(-x)
pf1(x) = -exp(1 - x)
pf2(x) = -exp(-x)*(x - 1)
δ = 10.0^(-5)
ϵ = 10.0^(-5)
MAXIT = 1024

function test_bisekcji(a, b, f)
    (x, fx, it, err) = RootsModule.mbisekcji(f, a, b, δ, ϵ)
    result = ("Bisekcja", "[$a, $b]", x, fx, it)
    return result
end

function test_newton(x0, f, pf)
    (x, fx, it, err) = RootsModule.mstycznych(f, pf, x0, δ, ϵ, MAXIT)
    result = ("Newton", "x_0 = $x0", x, fx, it)
    return result
end

function test_siecznych(x0, x1, f)
    (x, fx, it, err) = RootsModule.msiecznych(f, x0, x1, δ, ϵ, MAXIT)
    result = ("Sieczne", "x_0 = $x0, x_1 = $x1", x, fx, it)
    return result
end

dataSetF1 = []
dataSetF2 = []
funs = [(f1, pf1, dataSetF1), (f2, pf2, dataSetF2)]
testBisectRanges = [
    (-1.0, 1.0), (-2.0, 3.5), (-0.05, 1.05), (0.55, 1.55), (-50.0, 60.0),
    (-5.0, 6.0), (-100.0, 50.0)
]
testNewtonPoint = [-500.0, -100.0, -10.0, -1.0, 0.5, 7.0, 8.0]
testSiecznePoints = [(-2.0, -1.0)]

for (ff, ppf, dset) in funs
    for (a, b) in testBisectRanges
        push!(dset, test_bisekcji(a, b, ff))
    end
end

for (ff, ppf, dset) in funs
    for x0 in testNewtonPoint
        push!(dset, test_newton(x0, ff, ppf))
    end
end

for (ff, ppf, dset) in funs
    for (x0, x1) in testSiecznePoints
        push!(dset, test_siecznych(x0, x1, ff))
    end
end

push!(dataSetF1, test_newton(50.0, f1, pf1))
push!(dataSetF1, test_newton(10.0, f1, pf1))
push!(dataSetF1, test_newton(0.5, f1, pf1))

push!(dataSetF2, test_newton(10.0, f2, pf2))
push!(dataSetF2, test_newton(5.0, f2, pf2))
push!(dataSetF2, test_newton(1.0, f2, pf2))
push!(dataSetF2, test_newton(0.5, f2, pf2))

println("f1")
RootsModule.printAsTexTable(dataSetF1)
println("f2")
RootsModule.printAsTexTable(dataSetF2)
