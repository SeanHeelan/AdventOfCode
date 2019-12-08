using Printf: @printf, @sprintf

import Logging

logger = Logging.SimpleLogger(stderr, Logging.Debug)
Logging.global_logger(logger)

@enum Direction begin
    Up 
    Down
    Left
    Right
end

struct PathStep
    direction::Direction
    magnitude::Int
end

"""Construct a PathStep struct from a string. The first character gives the direction
and the remainder give the magnitude.
"""
function pathstep_from_string(s)
    direction_str = s[1]
    if direction_str == 'U'
        direction = Up
    elseif direction_str == 'D'
        direction = Down
    elseif direction_str == 'L'
        direction = Left
    elseif direction_str == 'R'
        direction = Right
    else
        error(@sprintf("Invalid direction string %s", direction_str))
    end

    magnitude = parse(UInt, s[2:length(s)])

    PathStep(direction, magnitude)
end

"""Load two lines from the input file that describe the paths taken by two wires.
The two paths are represented as vectors of PathStep structures.
"""
function load_wire_paths(input_file)
    paths = Vector{Vector{PathStep}}()
    for line in eachline(input_file)
        split_line = split(line, ",")
        path = Vector{PathStep}()
        for op in split_line
            step = pathstep_from_string(op)
            push!(path, step)
        end
        push!(paths, path)
    end

    paths[1], paths[2]
end

"""Plot the path taken by a wire as described by a series of directions. The resulting
path is returned as a vector of tuples giving x and y coordinates.
"""
function plot_path(directions)
    # Represent the path as a vector of tuples that indicate coordinates (x, y)
    path = Vector{Tuple{Int, Int}}()
    push!(path, (0, 0))

    for step in directions
        curr_pos = path[end]
        if step.direction == Up
            for y = 1:step.magnitude
                push!(path, (curr_pos[1], curr_pos[2] + y))
            end
        elseif step.direction == Down
            for y = 1:step.magnitude
                push!(path, (curr_pos[1], curr_pos[2] - y))
            end
        elseif step.direction == Right
            for x = 1:step.magnitude
                push!(path, (curr_pos[1] + x, curr_pos[2]))
            end
        elseif step.direction == Left
            for x = 1:step.magnitude
                push!(path, (curr_pos[1] - x, curr_pos[2]))
            end
        else
            error("Invalid step direction")
        end
    end
    
    path
end

"""Find the points at which the two provided paths intersect. They are returned
as a vector of tuples, giving x and y coordinates.
"""
function find_intersections(path0_coords, path1_coords)
    intersections = Vector{Tuple{Int, Int}}()

    for path0_point in path0_coords
        for path1_point in path1_coords
            if path0_point == path1_point
                push!(intersections, path0_point)
            end
        end
    end

    intersections
end

"""Calculate the manhattan distance between two points in a 2D Euclidean space"""
function manhattan_distance(a, b)
    abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function find_closest_point_to_origin(points)
    origin = (0, 0)
    shortest = manhattan_distance(origin, intersection_points[1])
    for intersection_point in intersection_points[2:end]
        d = manhattan_distance(origin, intersection_point)
        if d < shortest
            shortest = d
        end
    end

    shortest
end

input_file = ARGS[1]
@printf("Loading wire paths from %s\n", input_file)
path0_steps, path1_steps = open(load_wire_paths, input_file)

@printf("Path 0 length: %d, path 1 length: %d\n", length(path0_steps), length(path1_steps))

@printf("Plotting path 0 ...\n")
path0_coords = plot_path(path0_steps)
@printf("Plotting path 1 ...\n")
path1_coords = plot_path(path1_steps)
@printf("Finding intersection points ...\n")

intersection_points = find_intersections(path0_coords[2:end], path1_coords[2:end])
@printf("%d intersection points found\n", length(intersection_points))

if length(intersection_points) < 1
    printf("Failure: no intersection points\n")
    exit(1)
end

@printf("Calculating shortest distance ...\n")
shortest = find_closest_point_to_origin(intersection_points)

@printf("Shortest distance: %d\n", shortest)