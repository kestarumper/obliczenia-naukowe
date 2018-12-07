push!(LOAD_PATH, ".")
using Ilorazy
using Base.Test

x = Float64[3, 1, 5, 6]
f = Float64[1, -3, 2, 4]
@testset "Testy jednostkowe funkcji IlorazyRóżnicowe" begin
    @test Ilorazy.ilorazyRoznicowe(x, f) ≈ [1.0, 2.0, -0.375, 0.175]
end
