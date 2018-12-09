# @author Adrian Mucha
push!(LOAD_PATH, ".")
using Ilorazy
using Base.Test

x = Float64[5, -7, -6, 0]
fx = Float64[1, 2, 3, 4]
@testset "Testy jednostkowe funkcji naturalna" begin
    #1 + 2(x-5) + 3(x-5)(x+7) + 4(x-5)(x+7)(x+6) == -954 - 84x + 35x^2 + 4x^3
    @test Ilorazy.naturalna(x, fx) ≈ [-954.0, -84.0, 35.0, 4.0]

    #3 + 6(x-1) + 9(x-1)(x-2) == 15 - 21x + 9x^2
    @test Ilorazy.naturalna([1.0, 2.0, 3.0], [3.0, 6.0, 9.0]) ≈ [15.0, -21.0, 9.0]
end
