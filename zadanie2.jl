"""
@author Adrian Mucha
"""
function kahanMachEps(dataType)
    a = dataType(3.0)
    b = dataType(4.0)
    c = dataType(1.0)
    return dataType((a * ((b / a) - c) - c))
end

DATATYPES = [Float16, Float32, Float64]

for dataType in DATATYPES
    println("$dataType")
    println("KAHAN = $(kahanMachEps(dataType))")
    println("eps = $(eps(dataType))\n")
end
