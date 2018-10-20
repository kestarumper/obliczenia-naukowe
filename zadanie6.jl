"""
@author Adrian Mucha
"""
f(x) = Float64(sqrt(x^2 + 1.0) - 1.0)
g(x) = Float64(x^2 / (sqrt(x^2 + 1.0) + 1.0))

for i in 1:10
    x = 8.0^(-i)
    print("\$8^{-$i}\$ & \$$(f(x))\$ & ")
    println("\$$(g(x))\$ \\\\")
end
