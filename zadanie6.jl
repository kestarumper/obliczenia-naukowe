"""
@author Adrian Mucha
"""
f(x) = Float64(sqrt(x^2 + 1) - 1)
g(x) = Float64(x^2 / (sqrt(x^2 + 1) + 1))

for i in 1:32
    x = 8.0^(-i)
    println("f(8^(-$i)) = $(f(x))")
    println("g(8^(-$i)) = $(g(x))\n")
end
