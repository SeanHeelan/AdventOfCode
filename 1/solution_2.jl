using Printf

function calculate_fuel(mass) 
    total = 0.0
    while mass > 0.0 
        extra_fuel = floor(mass / 3.0) - 2.0
        if extra_fuel > 0.0
            total += extra_fuel
        end
        mass = extra_fuel     
    end
    total
end

function calculate_total_fuel(f)
    total = 0.0
    for line in eachline(f)
        v = parse(Float64, line)
        total += calculate_fuel(v)
    end

    total
end

r = open(calculate_total_fuel, "input.txt")
@printf("%f\n", r)
