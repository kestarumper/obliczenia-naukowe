function floatNumberStep(from::Float64, to::Float64, δ::Float64)
    println("\nRange [$from:$to)")
    for k in 1:3
        x = from + k*δ
        print(rpad(x, 24))
        print(bits(x))
        print("\n")
    end
    println("")
    for k in 3:-1:1
        x = to - k*δ
        print(rpad(x, 24))
        print(bits(x))
        print("\n")
    end
end

floatNumberStep(0.5, 1.0, 2.0^(-53))
floatNumberStep(1.0, 2.0, 2.0^(-52))
floatNumberStep(2.0, 4.0, 2.0^(-51))
