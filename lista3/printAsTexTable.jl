function printAsTexTable(tuptup)
    for tup in tuptup
        len = length(tup)
        print(tup[1])
        if(len > 1)
            for i in 2:len
                print(" & ", tup[i])
            end
        end
        println(" \\\\")
    end
end
