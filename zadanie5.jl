"""
@author Adrian Mucha
"""
x = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

function forwardSum(a, b, n, dataType)
    S = dataType(0.0)
    for i in 1:n
        ai = dataType(a[i])
        bi = dataType(b[i])
        S += dataType(ai * bi)
    end
    return S
end

function reverseSum(a, b, n, dataType)
    S = dataType(0.0)
    i = n
    while i > 0
        S += dataType(a[i]) * dataType(b[i])
        i = i - 1
    end
    return S
end

function sumPositiveNegative(a, b, dataType, reverse=true)
    s_plus = dataType(0.0)
    s_minus = dataType(0.0)
    v = zeros(5)
    for i in 1:5
        v[i] = dataType(a[i])*dataType(b[i])
    end
    sort!(v, rev=reverse)
    for val in v
        if(val < 0)
            s_minus += val
        else
            s_plus += val
        end
    end
    return dataType(s_plus + s_minus)
end

DATATYPES = [Float32, Float64]

for dtype in DATATYPES
    fs = forwardSum(x, y, 5, dtype)
    rs = reverseSum(x, y, 5, dtype)
    spn = sumPositiveNegative(x, y, dtype)
    spnr = sumPositiveNegative(x, y, dtype, false)
    println("\n$dtype")
    println("Forward Sum: $fs")
    println("Reverse Sum: $rs")
    println("Positive + Negative: $spn")
    println("Positive + Negative (reversed): $spnr")
end
