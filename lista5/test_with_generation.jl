push!(LOAD_PATH, ".")
using Blocksys
using matrixgen
using Base.Test
println("")

# dataFileSizes = ["16"]
dataFileSizes = [16, 100, 1000, 10000]
for dsize in dataFileSizes
    @testset "$(lpad("Matrix ∈ $(dsize)×$(dsize)", 32))" begin
        subMatrixSize = 4
        matrixCondition = 1.0
        matFile_A = "$(pwd())/Generated/A_$(dsize).txt"

        blockmat(dsize, subMatrixSize, matrixCondition, matFile_A)
        ORIGINAL_A, n, l = loadMatFromFile(matFile_A)
        ORIGINAL_b = calculateRightSideVector(n, ORIGINAL_A, subMatrixSize)

        printSparse(ORIGINAL_A, n)

        @testset "Calculate right side vector" begin
            b = calculateRightSideVector(n, ORIGINAL_A, l)
            @test b ≈ ORIGINAL_b
        end

        @testset "Specific WITHOUT choice" begin
            @testset "Solve with Gaussian Elimination SPECIFIC" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, false, true)
                @test x ≈ ones(n)
            end

            @testset "Solve LU" begin
                A, p = buildLU(n, ORIGINAL_A, l, false)
                x = solveLU(n, A, ORIGINAL_b, l, p)
                @test x ≈ ones(n)
            end
        end

        @testset "Specific with CHOICE" begin
            @testset "Solve with Gaussian Elimination SPECIFIC with CHOICE" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true, true)
                @test x ≈ ones(n)
            end

            @testset "Solve LU" begin
                A, p = buildLU(n, ORIGINAL_A, l, true)
                x = solveLU(n, A, ORIGINAL_b, l, p)
                @test x ≈ ones(n)
            end
        end
    end
end
