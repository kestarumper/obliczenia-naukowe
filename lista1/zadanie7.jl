# @author Adrian Mucha

"""
Calculates approximated value of a derivative of given function `func`
in given point `x0` with precision to 2.0^{-n}.
"""
function derivative(func::Function, x0::Float64 = 1.0, n::Int = 28)
    h = 2.0^(-n)
    return (func(x0 + h) - f(x0)) / h
end

"""
Prints truples (a, b, c) and formats them for Latex use.
"""
function printTruplets(truplets)
    for trup in truplets
        print(rpad("\$2^{-$(trup[1])}\$ & \$", 8))
        print(rpad(trup[2], 24))
        print("\$ & \$$(trup[3])\$ \\\\\n")
    end
end

f(x) = sin(x) + cos(3.0x)
fprim(x) = cos(x) - 3.0sin(3.0x)

x0 = 1.0
prim = fprim(x0)
dataset = []
smallestErr = (-1, realmax(Float64))
for n in 0:54
    val = derivative(f, x0, n)
    err = abs(prim - val)
    if smallestErr[2] > err
        smallestErr = (n,err)
    end
    push!(dataset, (n, val, err))
end

printTruplets(dataset)
println("Minimal error: $(smallestErr[2]) for n = $(smallestErr[1])")

# toplot_x(arr) = [sample[1] for sample in arr]
# toplot_y(arr) = [sample[3] for sample in arr]
# args = toplot_y(dataset)
# plot(toplot_x(dataset), toplot_y(dataset), title="Error due to original value", dpi=600)
# scatter!(toplot_x(dataset), toplot_y(dataset))
