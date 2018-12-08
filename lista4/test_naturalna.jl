push!(LOAD_PATH, ".")
using Ilorazy
using Base.Test

x = Float64[5, -7, -6, 0]
fx = Float64[1, 2, 3, 4]
@testset "Testy jednostkowe funkcji naturalna" begin
    @test Ilorazy.naturalna(x, fx) ≈ [-954.0, -84.0, 35.0, 4.0]
    @test Ilorazy.naturalna([-2.0], [4.0]) ≈ [4.0]
end
