# @author Adrian Mucha
push!(LOAD_PATH, ".")
using Ilorazy
using Plots
gr()
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
    x = [(a + k * h) for k in 0:n]
    y = f.(x)
    fx = Ilorazy.ilorazyRoznicowe(x, y)

    fy(t) = Ilorazy.warNewton(x, fx, t)

    range = linspace(a, b, 200)
    funs = [f, fy]
    labs = ["normalny", "interpolowany"]

    plt = plot(range, funs, label=labs)
    png(plt, fname)
end
