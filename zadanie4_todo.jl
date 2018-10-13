
function xnotx()
    x = nextfloat(Float64(1.0))
    one = Float64(1.0)
    while x * (one/x) == one && x < 2.0
        x = nextfloat(x)
    end
    return x # 1.000000057228997
end

println(xnotx())

# b)
