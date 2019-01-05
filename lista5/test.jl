push!(LOAD_PATH, ".")
using Blocksys
using Base.Test
println("")

@testset "Standard Gauss" begin
    @testset "Gaussian Elimination" begin
        A = SparseMatrixCSC(Float64[
            6 -2 2 4;
            12 -8 6 10;
            3 -13 9 3;
            -6 4 1 -18
        ])
        A_After = SparseMatrixCSC(Float64[
            6 -2 2 4;
            0 -4 2 2;
            0 0 2 -5;
            0 0 0 -3
        ])
        b = Float64[12, 34, 27, -38]
        b_After = Float64[12, 10, -9, -3]
        A_computed, b_computed = gaussElimination(4, A, b)
        @test A_computed ≈ A_After
        @test b_computed ≈ b_After
    end

    @testset "backwardSubstitution with triangleUpperMatrix" begin
        A = SparseMatrixCSC(Float64[6 -2 2 4; 0 -4 2 2; 0 0 2 -5; 0 0 0 -3])
        b = Float64[12, 10, -9, -3]
        x = backwardSubstitution(4, A, b)
        @test x ≈ Float64[1, -3, -2, 1]
    end
end

# dataFileSizes = ["16", "10000", "50000"]
dataFileSizes = ["16"]
for size in dataFileSizes
    @testset "$(lpad("Matrix ∈ $(size)×$(size)", 32))" begin
        matFile_A = "$(pwd())/Dane$(size)_1_1/A.txt"
        vecFile_b = "$(pwd())/Dane$(size)_1_1/b.txt"
        ORIGINAL_A, n, l = loadMatFromFile(matFile_A)
        printSparse(ORIGINAL_A, n)
        ORIGINAL_b = loadVecFromFile(vecFile_b)

        @testset "Specific WITHOUT choice" begin
            @testset "Solve with Gaussian Elimination SPECIFIC" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l)
                printSparse(A, n)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, false, true)
                printSparse(A, n, p)
                @test x ≈ ones(n)
            end

            @testset "Solve LU" begin
                A, p = buildLU(n, ORIGINAL_A, l, false)
                x = solveLU(n, A, ORIGINAL_b, l, p)
                @test x ≈ ones(n)
            end
        end

        @testset "Specific with CHOICE" begin
            println("KAPPA")
            @testset "Solve with Gaussian Elimination SPECIFIC with CHOICE" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true)
                printSparse(A, n, p)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true, true)
                printSparse(A, n, p)
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
