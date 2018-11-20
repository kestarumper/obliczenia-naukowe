push!(LOAD_PATH, "/home/adrian/obliczenia-naukowe/lista3/")
using RootsModule

y(x) = 3x - exp(x)
a = 0.0
b = 1.5
δ = 10.0^(-4)
ϵ = 10.0^(-4)

println(RootsModule.mbisekcji(y, a, b, δ, ϵ))
