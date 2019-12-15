using Printf: @printf, @sprintf

import Logging

logger = Logging.SimpleLogger(stderr, Logging.Debug)
Logging.global_logger(logger)

"""Determine if the provided password meets the elves criteria:

- Two adjacent digits are the same (like 22 in 122345).
- Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
- The two adjacent matching digits are not part of a larger group of matching digits.
"""
function meets_password_criteria(password)
    exploded = reverse(digits(password))

    adjacent_found = false
    adjacent_locked_in = false  
    in_group = false
    for idx in 1:length(exploded) - 1
        if exploded[idx + 1] < exploded[idx]                        
            return false
        end

        if adjacent_locked_in
            continue
        end

        if exploded[idx] == exploded[idx + 1]
            if in_group
                adjacent_found = false
            else
                adjacent_found = true
                in_group = true  
            end     
        else
            if adjacent_found
                adjacent_locked_in = true
            end
            in_group = false  
        end        
    end

    return adjacent_found 
end

"""Find the number of valid passwords in the provided range"""
function count_valid_passwords(s, e)
    pw_count = 0
    password = s
    while password <= e        
        if meets_password_criteria(password) == true
            pw_count += 1
        end
        password += 1
    end

    return pw_count
end

function main()
    range_str = ARGS[1]
    s1, s2 = split(range_str, "-")
    range_start = parse(Int, s1)
    range_end = parse(Int, s2)
    @printf("Finding passwords in range %d-%d ...\n", range_start, range_end)

    num_passwords = count_valid_passwords(range_start, range_end)
    @printf("Password count: %d\n", num_passwords)
end

main()