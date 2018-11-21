push!(LOAD_PATH, ".")
using RootsModule

y(x) = 3x - exp(x)
δ = 10.0^(-4)
ϵ = 10.0^(-4)

println(RootsModule.mbisekcji(y, 0.0, 1.0, δ, ϵ))
println(RootsModule.mbisekcji(y, 1.0, 2.0, δ, ϵ))
