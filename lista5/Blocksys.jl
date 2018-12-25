module Blocksys
    export loadMatFromFile,
            loadVecFromFile,
            printSparse,
            backwardSubstitution,
            gaussElimination,
            gaussEliminationSpecific

    function parseInt(x)
        return parse(Int, x)
    end

    function parseFloat(x)
        return parse(Float64, x)
    end

    function tokNextLine(f)
        return split(readline(f))
    end

    function printSparse(array::SparseMatrixCSC{Float64, Int64}, n, p=1:n)
        idx = 1
        for i in p
            for j=1:n
                print_with_color(array[i, j] == 0.0 ? :default : j >= idx ? :blue : :yellow, @sprintf("%8.3f", array[i,j]))
            end
            idx += 1
            println("")
        end
		println("")
    end

    function loadMatFromFile(path)
        open(path) do file
            n, l = [ parseInt(tok) for tok in tokNextLine(file) ]
            A = spzeros(Float64, n, n)
            while !eof(file)
                toks = tokNextLine(file)
                i, j, val = parseInt(toks[1]), parseInt(toks[2]), parseFloat(toks[3])
                A[i, j] = val
            end
            return A, n, l
        end
    end

    function loadVecFromFile(path)
        b = zeros(0)
        open(path) do file
            n = parseInt(readline(file))
            while !eof(file)
                push!(b, parseFloat(readline(file)))
            end
        end
        return b
    end

    function backwardSubstitution(n::Int64, a::SparseMatrixCSC{Float64, Int64}, b::Array{Float64, 1}, p = 1:n, l::Int = 0)
        x = zeros(n)
        for i in n:-1:1
			lastColumn = n
			if l > 0
				lastColumn = min(n, Int(2l + l * floor(p[i] / l)))
			end
            s = b[p[i]]
            for j in (i+1):lastColumn
                s -= a[p[i], j] * x[j]
            end
            x[i] = s / a[p[i], i]
        end
        return x
    end

    function gaussElimination(n::Int, A::SparseMatrixCSC{Float64, Int}, b::Array{Float64, 1}, p = 1:n)
        a = deepcopy(A)
        b = deepcopy(b)
        for k in 1:n-1
            for i in k+1:n
                z = a[p[i], k] / a[p[k], k]
                a[p[i], k] = 0
                b[p[i]] -= z * b[p[k]]
                for j in k+1:n
                    a[p[i], j] -= z * a[p[k], j]
                end
            end
        end
		x = backwardSubstitution(n, a, b)
        return a, b, x
    end

    function gaussEliminationSpecific(n::Int, A::SparseMatrixCSC{Float64, Int}, b::Array{Float64, 1}, l::Int, choice::Bool = false, buildLU::Bool = false)
		p = collect(1:n)
        a = deepcopy(A)
        b = deepcopy(b)
        for k in 1:n-1
			lastColumn = min(n, Int64(2l + l * floor(k / l))) # calculate modyfing range
            lastRow = min(n, Int64(l + l * floor(k / l))) # calculate zeroing range
            for i in k+1:lastRow
				if choice
					maxRow = k
					max = abs(a[p[k], k])
					for x in i : lastRow
						if (abs(a[p[x], k]) > max)
							maxRow = x;
							max = abs(a[p[x], k])
						end
					end
					p[k], p[maxRow] = p[maxRow], p[k]
				end
				if eps(Float64) > abs(a[p[k], k])
					error("Zero on diagonall")
				end
                z = a[p[i], k] / a[p[k], k] # multiplier
				if buildLU
					a[p[i], k] = z	# save multipliers for LU
				else
					a[p[i], k] = 0  # eliminate under diagonal
				end
                b[p[i]] -= z * b[p[k]]  # modify right side vector
                for j in k+1:lastColumn
                    a[p[i], j] -= z * a[p[k], j]    # modify current row
                end
            end
        end

		x = backwardSubstitution(n, a, b, p, l)
        return a, b, p, x
    end

	function buildLU(n::Int, A::SparseMatrixCSC{Float64, Int}, l::Int, choice::Bool = false)
		p = collect(1:n)
        a = deepcopy(A)
        for k in 1:n-1
			lastColumn = min(n, Int64(2l + l * floor(k / l))) # calculate modyfing range
            lastRow = min(n, Int64(l + l * floor(k / l))) # calculate zeroing range
            for i in k+1:lastRow
				if choice
					maxRow = k
					max = abs(a[p[k], k])
					for x in i : lastRow
						if (abs(a[p[x], k]) > max)
							maxRow = x;
							max = abs(a[p[x], k])
						end
					end
					p[k], p[maxRow] = p[maxRow], p[k]
				end
				if eps(Float64) > abs(a[p[k], k])
					error("Zero on diagonall")
				end
                z = a[p[i], k] / a[p[k], k] # multiplier
				a[p[i], k] = z	# save multipliers for LU
                for j in k+1:lastColumn
                    a[p[i], j] -= z * a[p[k], j]    # modify current row
                end
            end
        end
        return a, p
	end
end

using Blocksys
using Base.Test
println("")

matFile_16_A = "$(pwd())/Dane16_1_1/A.txt"
vecFile_16_b = "$(pwd())/Dane16_1_1/b.txt"
ORIGINAL_A, n, l = loadMatFromFile(matFile_16_A)
printSparse(ORIGINAL_A, n)
ORIGINAL_b = loadVecFromFile(vecFile_16_b)

# @testset "Standard Gauss" begin
# 	@testset "Gaussian Elimination" begin
# 		A = SparseMatrixCSC(Float64[
# 			6 -2 2 4;
# 			12 -8 6 10;
# 			3 -13 9 3;
# 			-6 4 1 -18
# 		])
# 		A_After = SparseMatrixCSC(Float64[
# 			6 -2 2 4;
# 			0 -4 2 2;
# 			0 0 2 -5;
# 			0 0 0 -3
# 		])
# 		b = Float64[12, 34, 27, -38]
# 		b_After = Float64[12, 10, -9, -3]
# 		A_computed, b_computed = gaussElimination(4, A, b)
# 		@test A_computed ≈ A_After
# 		@test b_computed ≈ b_After
# 	end
#
# 	@testset "backwardSubstitution with triangleUpperMatrix" begin
# 		A = SparseMatrixCSC(Float64[6 -2 2 4; 0 -4 2 2; 0 0 2 -5; 0 0 0 -3])
# 		b = Float64[12, 10, -9, -3]
# 		x = backwardSubstitution(4, A, b)
# 		@test x ≈ Float64[1, -3, -2, 1]
# 	end
#
# 	@testset "Solve with standard Gauss Elimination" begin
# 		A, b, x = gaussElimination(n, ORIGINAL_A, ORIGINAL_b)
# 		@test x ≈ ones(Float64, n)
# 	end
# end

@testset "Normal" begin
	@testset "Solve with Gaussian Elimination SPECIFIC" begin
		A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l)
		printSparse(A, n)
		@test x ≈ ones(Float64, n)
	end

	@testset "Build LU matrix" begin
		A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, false, true)
		printSparse(A, n, p)
	end
end

@testset "With CHOICE" begin
	@testset "Solve with Gaussian Elimination SPECIFIC with CHOICE" begin
		A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true)
		printSparse(A, n, p)
		@test x ≈ ones(Float64, n)
	end

	@testset "Build LU matrix" begin
		A, b, p, x = gaussEliminationSpecific(n, ORIGINAL_A, ORIGINAL_b, l, true, true)
		printSparse(A, n, p)
	end
end
