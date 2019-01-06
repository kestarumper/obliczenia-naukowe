push!(LOAD_PATH, ".")
using Blocksys
using Base.Test
println("")

dataFileSizes = ["16", "10000", "50000"]
for dsize in dataFileSizes
    matFile_A = "$(pwd())/Dane$(dsize)_1_1/A.txt"
    vecFile_b = "$(pwd())/Dane$(dsize)_1_1/b.txt"

    ORIGINAL_A, n, l = loadMatFromFile(matFile_A)
    ORIGINAL_b = loadVecFromFile(vecFile_b)

    @testset "Gauss $dsize" begin
        A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l)
        expected = ones(Float64, n)
        @test x ≈ expected
        err = relErr(x, expected)
        saveVectorToFile("relErr_Gauss_$dsize.txt", x, n, true)
    end

    @testset "Gauss z wyborem $dsize" begin
        A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l, true)
        expected = ones(Float64, n)
        @test x ≈ expected
        saveVectorToFile("relErr_Gauss_Choice_$dsize.txt", x, n, true)
    end

    @testset "LU $dsize" begin
        A, p = buildLU(n, deepcopy(ORIGINAL_A), l)
        x = solveLU(n, A, deepcopy(ORIGINAL_b), l, p)
        @test x ≈ ones(n)
        saveVectorToFile("relErr_LU_$dsize.txt", x, n, true)
    end

    @testset "LU z wyborem $dsize" begin
        A, p = buildLU(n, deepcopy(ORIGINAL_A), l, true)
        x = solveLU(n, A, deepcopy(ORIGINAL_b), l, p)
        @test x ≈ ones(n)
        saveVectorToFile("relErr_LU_Choice_$dsize.txt", x, n, true)
    end
end
