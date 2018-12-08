push!(LOAD_PATH, ".")
using Ilorazy

ns = [5, 10, 15, 25, 50]
func(x) = x^2*sin(x)

testCases = [
    (exp, 0.0, 1.0, "exp")
    (func, -1.0, 1.0, "x2sinx")
]

for tc in testCases
    (f, a, b, fname) = tc
    for n in ns
        fullFileName = "$(fname)_$(n).png"
        print("Drawing $fullFileName...")
        Ilorazy.rysujNnfx(f, a, b, n, fullFileName)
        println("Done.")
    end
end
