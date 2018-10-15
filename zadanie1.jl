function machEps(dataType)
    epsilon = dataType(1)
    one = dataType(1)
    while (one + (epsilon/2)) != one
        epsilon = epsilon/2
    end
    return epsilon
end

function myEta(dataType)
    x = dataType(1)
    while x / 2 != 0
       x = x / 2
    end
    return x
end

function MAX(dataType)
    x = dataType(1)
    while isinf(x * dataType(2.0)) == false
        x = x * dataType(2.0)
    end
    x = x * (dataType(2.0) - eps(dataType))
    return x
end

DATATYPES = [Float16, Float32, Float64]

println("a)")
for dataType in DATATYPES
    println(dataType)
    println("machEps = $(machEps(dataType))")
    println("eps = $(eps(dataType))")
    println(bits(eps(dataType)))
    println("")
end

println("b)")
for dataType in DATATYPES
    println(dataType)
    println("myEta = $(myEta(dataType))")
    println("nextfloat = $(nextfloat(dataType(0.0)))")
    println(bits(myEta(dataType)))
    println("")
end

println("c)")
for dataType in DATATYPES
    println(dataType)
    println("MAX = $(MAX(dataType))")
    println("realmax = $(realmax(dataType))")
    println(bits(MAX(dataType)))
    println("")
end
