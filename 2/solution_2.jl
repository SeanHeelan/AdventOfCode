using Printf: @printf
using Logging: @debug, SimpleLogger, global_logger, Debug, Info

logger = SimpleLogger(stderr, Info)
global_logger(logger)

"""Load a program from a text file into a vector of unsigned integers and return it."""
function load_program(input_file) 
    input_text = read(input_file, String)
    split_text = split(input_text, ",")
    program = Vector{UInt}()
    for i = 1:length(split_text)
        push!(program, parse(UInt, split_text[i]))
    end

    program
end

"""Set the program arguments to the provided values"""
function set_program_arguments!(program, arg0, arg1)
    program[2] = arg0
    program[3] = arg1

    nothing
end

"""Handle an add instruction"""
function handle_add!(program, op_idx)
    op1 = program[op_idx + 1] + 1
    op2 = program[op_idx + 2] + 1
    op3 = program[op_idx + 3] + 1
    
    val = program[op1] + program[op2]
    @debug "Handling OP_ADD " op_idx, op1, op2, val, op3 
    program[op3] = val
    nothing
end

"""Handle a mul instruction"""
function handle_mul!(program, op_idx)
    op1 = program[op_idx + 1] + 1
    op2 = program[op_idx + 2] + 1
    op3 = program[op_idx + 3] + 1

    val = program[op1] * program[op2]
    @debug "Handling OP_MUL " op_idx, op1, op2, val, op3 
    program[op3] = val
    nothing
end

OP_ADD = 1
OP_MUL = 2
OP_END = 99

"""Execute the provided program"""
function execute_program!(program)
    idx = 1
    while idx <= length(program)
        opcode = program[idx]
        if opcode == OP_ADD
            handle_add!(program, idx)
        elseif opcode == OP_MUL
            handle_mul!(program, idx)
        elseif opcode == OP_END
            return nothing
        end
        idx += 4
    end
    
    nothing
end

"""Return the first element in the program array, which is the result"""
function get_result(program)
    program[1]
end

input_file = "input.txt"
@printf("Loading program from %s ...\n", input_file)

original_program = open(load_program, input_file)
@printf("Program length: %d\n", length(original_program))

for arg0 = 0:99
    for arg1 = 0:99
        program_copy = copy(original_program)
        set_program_arguments!(program_copy, arg0, arg1)
        execute_program!(program_copy)
        result = get_result(program_copy)
        if result == 19690720
            @printf("Found arguments: %d %d\n", arg0, arg1)
            @printf("Answer: %d\n", 100 * arg0 + arg1)
            exit(0)
        end
    end
end