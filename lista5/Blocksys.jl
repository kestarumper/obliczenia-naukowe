# @author Adrian Mucha
module Blocksys
    export loadMatFromFile,
            loadVecFromFile,
            printSparse,
            backwardSubstitution,
            gaussElimination,
            gaussEliminationSpecific,
			buildLU,
			solveLU,
			calculateRightSideVector,
			relErr,
			saveVectorToFile

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
		if n > 16
			return
		end
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

	"""
		Wykonuje podstawienie wstecz obliczając rozwiązanie
		input
			n - rozmiar macierzy a
			a - macierz trójkątna górna
			b - wektor prawych stron
			p - wektor permutacji
			l - rozmiar podmacierzy
		out
			x - wektor taki że ax = b
	"""
    function backwardSubstitution(n::Int64, a::SparseMatrixCSC{Float64, Int64}, b::Array{Float64, 1}, p = 1:n, l::Int = 0)
        x = zeros(n)
        for i in n:-1:1
			lastColumn = min(n, Int(2l + l * floor((p[i] - 1) / l)))
            s = b[p[i]]
            for j in (i+1):lastColumn
                s -= a[p[i], j] * x[j]
            end
            x[i] = s / a[p[i], i]
        end
        return x
    end

	"""
		Wykonuje podstawienie w przód obliczając rozwiązanie
		input
			n - rozmiar macierzy a
			a - macierz trójkątna dolna
			b - wektor prawych stron
			p - wektor permutacji
			l - rozmiar podmacierzy
		out
			x - ax = b
	"""
	function forwardSubstitution(n::Int64, a::SparseMatrixCSC{Float64, Int64}, b::Array{Float64, 1}, p = 1:n, l::Int = 0)
		# b = deepcopy(b)
		for k in 1:(n-1)
			lastRow = min(n, Int64(l + l * floor(k / l)))
			for i in (k+1):lastRow
				b[p[i]] -= a[p[i], k] * b[p[k]]
			end
		end
		return b
	end

	"""
		Wykonuje standardową eliminacje gaussa
		input
			n - rozmiar macierzy A
			A - macierz
			b - wektor prawych stron
			p - wektor permutacji
		out
			A - przekształcone do macierzy trójkątnej górnej
			b - zmodyfikowany wektor prawych stron
			x - wektor taki że Ax = b
	"""
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

	"""
		Wykonuje eliminacje gaussa uwzględniając specyficzną
		postać macierzy z zadania
		input
			n - rozmiar macierzy A
			a - macierz
			b - wektor prawych stron
			l - rozmiar podmacierzy
			choice - z wyborem czy bez
			buildLU - czy zapisywać mnożniki w miejsca eliminowanych elementów
		out
			a - przekształcone do macierzy trójkątnej górnej
			b - zmodyfikowany wektor prawych stron
			p - obliczony wektor permutacji
			x - wektor taki że Ax = b
	"""
    function gaussEliminationSpecific(n::Int, a::SparseMatrixCSC{Float64, Int}, b::Array{Float64, 1}, l::Int, choice::Bool = false, buildLU::Bool = false)
		p = collect(1:n)
        for k in 1:n-1
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

				lastColumn = min(n, Int64(2l + l * floor((i - 1) / l))) # calculate modyfing range
                for j in k+1:lastColumn
                    a[p[i], j] -= z * a[p[k], j]    # modify current row
                end
            end
        end

		x = backwardSubstitution(n, a, b, p, l)
        return a, b, p, x
    end

	"""
		Za pomocą eliminacji Gaussa oblicza macierz LU taką że a = LU
		input
			n - rozmiar macierzy A
			a - macierz
			l - rozmiar podmacierzy
			choice - z wyborem czy bez
			retIterations - czy zwrócić ilość wykonanych
							iteracji [na potrzeby testów]
		out
			a - przekształcone do macierzy LU
			p - obliczony wektor permutacji
	"""
	function buildLU(n::Int, a::SparseMatrixCSC{Float64, Int}, l::Int, choice::Bool = false, retIterations::Bool = false)
		p = collect(1:n)
        # a = deepcopy(A)
		iterations = 0
        for k in 1:n-1
            lastRow = min(n, Int64(l + l * floor(k / l))) # calculate zeroing range
			lastColumn = min(n, Int64(2l + l * floor((k - 1) / l))) # calculate modyfing range
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
					iterations += 1
                end
            end
        end
		if retIterations
			return a, p, iterations
		end
        return a, p
	end

	"""
	Rozwiązuje układ równań używając obliczonej wcześniej macierzy LU
	za pomocą dwóch układów Lz = b oraz Ux = z
	input
		n - rozmiar macierzy a
		a - macierz LU
		b - wektor prawych stron
		l - rozmiar podmacierzy
		p - wektor permutacji
	out
		x - wektor taki że ax = LUx = b
	"""
	function solveLU(n::Int, a::SparseMatrixCSC{Float64, Int}, b::Array{Float64, 1}, l::Int, p = 1:n)
		z = forwardSubstitution(n, a, b, p, l) # solve lower LU matrix
		x = backwardSubstitution(n, a, z, p, l) # solve upper LU matrix
		return x
	end

	"""
	Oblicza wektor prawych stron zakładając że x = [1,1,...,1]^T
	"""
	function calculateRightSideVector(n::Int, a::SparseMatrixCSC{Float64, Int}, l::Int)
		b = zeros(n)
		for row in 1:n
			colStart = max(Int64(l * floor((row - 1) / l)), 1)
			colEnd = min(row + l, n)
			for col in colStart:colEnd
				b[row] += a[row, col]
			end
		end
		return b
	end

	"""
	Calculates relative error of 2 vectors
	"""
	function relErr(x::AbstractVector, xtild::AbstractVector)
	    h = x - xtild
	    normDiff = Float64(norm(h))
	    xnorm = Float64(norm(x))
	    return Float64(normDiff / xnorm)
	end

	function saveVectorToFile(fname::String, x::Array{Float64}, n::Int64, calcErr::Bool)
		open(fname, "w") do f
			if calcErr
				println(f, norm(ones(n) - x) / norm(x))
			end
			for val in x
				println(f, val)
			end
		end
	end
end
