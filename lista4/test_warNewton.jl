push!(LOAD_PATH, ".")
using Ilorazy
using Base.Test

x = Float64[5, -7, -6, 0]
fx = Float64[1, 2, 3, 4]
@testset "Testy jednostkowe funkcji warNewton" begin
    @test Ilorazy.warNewton(x, fx, 0.0) ≈ -954.0
    @test Ilorazy.warNewton(x, fx, 1.0) ≈ -999.0
    @test Ilorazy.warNewton(x, fx, 5.0) ≈ 1
    @test Ilorazy.warNewton(x, fx, -5.0) ≈ -159.0
    @test Ilorazy.warNewton(x, fx, 21.37) ≈ 52271.3529
    @test Ilorazy.warNewton(x, fx, 5.03577) ≈ 21.37 atol=10.0^(-2)
end
