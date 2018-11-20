push!(LOAD_PATH, ".")
using RootsModule

f(x) = (x - 11)*(x - 23)
print(RootsModule.mbisekcji(f, 15.0, 100.0, eps(Float64), eps(Float64)))
