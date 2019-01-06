push!(LOAD_PATH, ".")
using Blocksys
using matrixgen
using Base.Test
using Plots
println("")

plot_x = []
plot_time = [[],[]]
plot_mem = []

function LU(n::Int, ORIGINAL_A::SparseMatrixCSC{Float64, Int}, ORIGINAL_b::Array{Float64, 1}, l::Int, choice::Bool)
    A, p = buildLU(n, ORIGINAL_A, l, choice)
    x = solveLU(n, A, ORIGINAL_b, l, p)
    return x
end

for dsize in 1000:1000:50000
    subMatrixSize = 4
    matrixCondition = 1.0
    matFile_A = "$(pwd())/Generated/A_$(dsize).txt"

    blockmat(dsize, subMatrixSize, matrixCondition, matFile_A)
    ORIGINAL_A, n, l = loadMatFromFile(matFile_A)
    ORIGINAL_b = calculateRightSideVector(n, ORIGINAL_A, subMatrixSize)

    @testset "Solve LU $(dsize)×$(dsize)" begin
        (A, p), timeBuildLU, memBuildLU = @timed buildLU(n, ORIGINAL_A, l, true)
        x, time, mem = @timed solveLU(n, A, ORIGINAL_b, l, p)
        push!(plot_x, dsize)
        push!(plot_time[1], time)
        push!(plot_time[2], timeBuildLU)
        push!(plot_mem, mem)
        @test x ≈ ones(n)
    end
end

p_time = plot(plot_x, plot_time, xlabel="Matrix size", ylabel="Time", seriestype=:scatter, title="Solve LU with choice")
p_mem = plot(plot_x, plot_mem, xlabel="Matrix size", ylabel="Mem", seriestype=:scatter, title="Solve LU with choice")
png(p_time, "SolveLuWithChoice_Time")
png(p_mem, "SolveLuWithChoice_Mem")
