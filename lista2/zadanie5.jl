include(joinpath(@__DIR__,"printAsTexTable.jl"))

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

function experiment12()
    dataSet = []
    println("\t", "Float32Trunc", "\t", Float32, "\t\t", Float64)
    for i in 1:40
        f32_trunc = iterPopGrowthModel(i, Float32, true)
        f32 = iterPopGrowthModel(i, Float32)
        f64 = iterPopGrowthModel(i, Float64)
        push!(dataSet, (i, f32_trunc, f32, f64))
        println(i, "\t", f32_trunc, "\t", f32, "\t", f64)
    end
    return dataSet
end

ds = experiment12()

# printAsTexTable(ds)
