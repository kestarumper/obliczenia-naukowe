# @author Adrian Mucha
using Polynomials
include(joinpath(@__DIR__,"printAsTexTable.jl"))

"""
Evaluates polynomial created from coefficients using 'Poly'
function with wilkinson polynomial created with 'poly' function
from module 'Polynomials'. Polynomials are evaluated at roots calculated
by 'roots' function.
"""
function evalPolynomials(cfs)
      coefficients = reverse(cfs)
      P = Poly(coefficients)
      p = poly(1:20)
      pierwiastki = roots(P)

      pad = 26
      dataSet = []
      for k in 20:-1:1
            zk = pierwiastki[20 - k + 1]
            valP = abs(P(zk))
            valp = abs(p(zk))
            h = abs(zk - k)
            push!(dataSet, (20 - k + 1, zk, valP, valp, h))
            println(
                  rpad("|P($zk)|", pad),
                  rpad("= $valP", pad),
                  rpad("|p($zk)|", pad),
                  rpad("= $valp", pad),
                  rpad("|$zk - $k|", pad),
                  "= $h"
            )
      end
      return dataSet
end

cfnts = [1, -210.0, 20615.0,-1256850.0,
      53327946.0,-1672280820.0, 40171771630.0, -756111184500.0,
      11310276995381.0, -135585182899530.0,
      1307535010540395.0,     -10142299865511450.0,
      63030812099294896.0,     -311333643161390640.0,
      1206647803780373360.0,     -3599979517947607200.0,
      8037811822645051776.0,      -12870931245150988800.0,
      13803759753640704000.0,      -8752948036761600000.0,
      2432902008176640000.0]
println("")
a = evalPolynomials(cfnts)
println("Change -210 → -210-2^{-23}")
cfnts[2] = -210 - 2.0^(-23)
b = evalPolynomials(cfnts)

# printAsTexTable(a)
# printAsTexTable(b)
