push!(LOAD_PATH, ".")
using Blocksys
using Base.Test
println("")

# dataFileSizes = ["16"]
dataFileSizes = ["16", "10000", "50000"]
for size in dataFileSizes
    @testset "$(lpad("Matrix ∈ $(size)×$(size)", 32))" begin
        matFile_A = "$(pwd())/Dane$(size)_1_1/A.txt"
        vecFile_b = "$(pwd())/Dane$(size)_1_1/b.txt"
        ORIGINAL_A, n, l = loadMatFromFile(matFile_A)
        printSparse(ORIGINAL_A, n)
        ORIGINAL_b = loadVecFromFile(vecFile_b)

        @testset "Calculate right side vector" begin
            b = calculateRightSideVector(n, deepcopy(ORIGINAL_A), l)
            @test b ≈ ORIGINAL_b
        end

        @testset "Specific WITHOUT choice" begin
            @testset "Solve with Gaussian Elimination SPECIFIC" begin
                A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l)
                printSparse(A, n)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l, false, true)
                printSparse(A, n, p)
                @test x ≈ ones(n)
            end

            @testset "Solve LU" begin
                A, p = buildLU(n, deepcopy(ORIGINAL_A), l, false)
                x = solveLU(n, A, deepcopy(ORIGINAL_b), l, p)
                @test x ≈ ones(n)
            end
        end

        @testset "Specific with CHOICE" begin
            @testset "Solve with Gaussian Elimination SPECIFIC with CHOICE" begin
                A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l, true)
                printSparse(A, n, p)
                @test x ≈ ones(Float64, n)
            end

            @testset "Build LU matrix" begin
                A, b, p, x = gaussEliminationSpecific(n, deepcopy(ORIGINAL_A), deepcopy(ORIGINAL_b), l, true, true)
                printSparse(A, n, p)
                @test x ≈ ones(n)
            end

            @testset "Solve LU" begin
                A, p = buildLU(n, deepcopy(ORIGINAL_A), l, true)
                x = solveLU(n, A, deepcopy(ORIGINAL_b), l, p)
                @test x ≈ ones(n)
            end
        end
    end
end
