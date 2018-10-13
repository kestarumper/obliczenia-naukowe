𝛿 = 2.0^(-52)
x = 2.0
# for k in 1:(2^52-1)
#     x = x + k*𝛿
#     print(rpad(x, 24))
#     print(bits(x))
#     print("\n")
#     if x > 4.0
#         break
#     end
# end
x = 1.0
while x > 0.0
    println(bits(x))
    x = x/2
end
