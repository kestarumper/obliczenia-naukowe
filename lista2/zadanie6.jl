using Plots

function iterate(n, x0, c, dt)
    result = dt(x0)
    for i in 1:n
        result = dt(dt(result ^ 2) + c)
    end
    return result
end

inputPairs = [
    (-2, 1),
    (-2, 2),
    (-2, 1.99999999999999),
    (-1, 1),
    (-1, -1),
    (-1, 0.75),
    (-1, 0.25)
]

dataset = []
counter = 1
for pair in inputPairs
    push!(dataset, [])
    for i in 1:40
        push!(dataset[counter], iterate(i, pair[2], pair[1], Float64))
    end
    plt = plot(dataset[counter])
    png(plt, "plot_$counter.png")
    counter += 1
end
