push!(LOAD_PATH, ".")
using Ilorazy
using Plots
"""
# Dane:
    f – funkcja f(x) zadana jako anonimowa funkcja,
    a,b – przedział interpolacji
    n – stopień wielomianu interpolacyjnego
# Wyniki:
    – funkcja rysuje wielomian interpolacyjny i interpolowaną
    funkcję w przedziale [a, b].
"""
function rysujNnfx(f, a::Float64, b::Float64, n::Int, fname="plot.png")
    h = Float64(abs((b-a))/n)
    x = [(a + k * h) for k in 0:n-1]
    y = f.(x)
    fx = Ilorazy.ilorazyRoznicowe(x, y)
    fy = [ Ilorazy.warNewton(x, fx, t) for t in x ]
    plt = plot(x, [y, fy], label=["normalny", "interpolowany"], dpi=600)
    png(plt, fname)
    return (x, y, fx, fy)
end
