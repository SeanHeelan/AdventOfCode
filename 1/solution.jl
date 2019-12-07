using Printf

function calculate_fuel(f)
    total = 0.0
    cnt = 0
    for line in eachline(f)
        v = parse(Float64, line)
        total += floor(v / 3.0) - 2.0
        cnt += 1
       
    end

    total
end

r = open(calculate_fuel, "/home/sean/source/AdventOfCode/1/input.txt")
@printf("%f\n", r)