#@author Adrian Mucha
push!(LOAD_PATH, ".")
using RootsModule

f(x) = (x - 11)*(x - 23)
pf(x) = 2x - 34

println(RootsModule.mbisekcji(f, 15.0, 100.0, eps(Float64), eps(Float64)))
println(RootsModule.mbisekcji(f, 1.0, 15.0, eps(Float64), eps(Float64)))

println(RootsModule.mstycznych(f, pf, 20.0, eps(Float64), eps(Float64), 1024))
println(RootsModule.mstycznych(f, pf, 10.0, eps(Float64), eps(Float64), 1024))

println(RootsModule.msiecznych(f, 18.0, 19.0, eps(Float64), eps(Float64), 1024))
println(RootsModule.msiecznych(f, 4.0, 6.0, eps(Float64), eps(Float64), 1024))