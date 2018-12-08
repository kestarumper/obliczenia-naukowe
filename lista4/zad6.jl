push!(LOAD_PATH, ".")
using Ilorazy

ns = [5, 10, 15]
f1(x) = abs(x)
f2(x) = 1.0 / ( 1.0 + x^2 )

testCases = [
    (f1, -1.0, 1.0, "|x|")
    (f2, -5.0, 5.0, "1div(1_plus_x2)")
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
