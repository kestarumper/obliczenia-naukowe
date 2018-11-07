

function iterPopGrowthModel(n, dt, rnding = false)
    p0 = dt(0.01)
    r = dt(3)
    pn = p0
    for i in 1:n
        pn = dt(pn + r * pn * dt(dt(1) - pn))
        if(rnding && i == 10 )
            pn = dt(trunc(pn, 3))
        end
    end
    return pn
end

function experiment1()
    for i in 1:40
        println(i, "\t", iterPopGrowthModel(i, Float32, true))
    end
end

function experiment2()
    println("\t", Float32, "\t\t", Float64)
    for i in 1:40
        f32 = iterPopGrowthModel(i, Float32)
        f64 = iterPopGrowthModel(i, Float64)
        println(i, "\t", f32, "\t", f64)
    end
end

experiment1()
experiment2()
