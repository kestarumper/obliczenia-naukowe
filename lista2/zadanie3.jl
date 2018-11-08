include(joinpath(@__DIR__,"hilb.jl"))
include(joinpath(@__DIR__,"matcond.jl"))

function relErr(x::AbstractVector, xtild::AbstractVector)
    h = x - xtild
    normDiff = Float64(norm(h))
    xnorm = Float64(norm(x))
    return Float64(normDiff / xnorm)
end

println("Hilbert")
hilbertResults = []
sumError = [0.0, 0.0]
for i in 1:50
    A = hilb(i)
    x = ones(Float64, (size(A)[1]))
    b = A*x

    gaussReduction = A \ b
    inversion = inv(A)*b
    errGauss = relErr(x, gaussReduction)
    errInv = relErr(x, inversion)
    matrixCond = cond(A)
    matrixRnk = rank(A)

    push!(hilbertResults, (i, errGauss, errInv, matrixCond, matrixRnk))
    sumError[1] = sumError[1] + errGauss
    sumError[2] = sumError[2] + errInv
    pad = 30
    println(
        lpad("Hn[$i×$i] ", 20),
        rpad("Gauss: $errGauss", pad),
        rpad("Inv: $errInv", pad),
        rpad("Cond: $matrixCond", pad),
        rpad("Rank: $matrixRnk", pad)
    )
end
println(sumError)

println("\nRandom")
narr = [5, 10, 20]
carr = Float64[1.0, 10.0, 10.0^3, 10.0^7, 10.0^12, 10.0^16]
randomResults = []
for n in narr
    for c in carr
        A = matcond(n, c)
        x = ones(Float64, (size(A)[1]))
        b = A*x

        gaussReduction = A \ b
        inversion = inv(A)*b
        errGauss = relErr(x, gaussReduction)
        errInv = relErr(x, inversion)
        matrixCond = cond(A)
        matrixRnk = rank(A)

        push!(randomResults, (n, c, errGauss, errInv, matrixCond, matrixRnk))
        pad = 30
        println(
            lpad("Rn{c=$c}[$n×$n] ", 20),
            rpad("Gauss: $errGauss", pad),
            rpad("Inv: $errInv", pad),
            rpad("Cond: $matrixCond", pad),
            rpad("Rank: $matrixRnk", pad)
        )
    end
end
