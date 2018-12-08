push!(LOAD_PATH, ".")
using Ilorazy
using Base.Test

x = Float64[3, 1, 5, 6]
f = Float64[1, -3, 2, 4]
@testset "Testy jednostkowe funkcji IlorazyRóżnicowe" begin
    @test Ilorazy.ilorazyRoznicowe(x, f) ≈ [1.0, 2.0, -0.375, 0.175]
    @test Ilorazy.ilorazyRoznicowe(
        Float64[5, -7, -6, 0],
        Float64[1, -23, -54, -954]
    ) ≈ [1.0, 2.0, 3.0, 4.0]
end
