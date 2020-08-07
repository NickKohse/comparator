#!/usr/bin/env ruby
require_relative 'helpers'
require_relative 'column.rb'

include Helpers

if ARGV.length != 1
    puts <<~USAGE
    USAGE:
    #{__FILE__} <filename.csv>
    USAGE
    exit 1
end

unless File.exists? ARGV[0]
    puts "#{ARGV[0]} is not a file"
    exit 1
end

# Read in file
read_legend = false
alternatives = Hash.new
columns = Array.new

File.read(ARGV[0]).each_line do |line|
    parts = line.split(',')
    if !read_legend
        for i in 1..parts.length - 1 do
            weight_part = parts[i].split('[')[1]
            weight = weight_part.scan(/\d+/).first

            if weight == nil
                puts "Weight at index #{i} improperly specified"
                exit 2
            end

            negate = weight_part.include?('^')
            columns.push(Column.new(weight.to_i, negate))
        end
        read_legend = true
    else
        values = Array.new
        for i in 1..parts.length - 1 do
            if !is_number(parts[i])
                puts "Alternative #{parts[0]} column #{i} has a non numeric value"
                exit 2
            else
                values.push(parts[i].to_f)    
            end
        end
        if values.length != columns.length
            puts "Alternative #{parts[0]} has #{values.length} values specified, but #{weights.length} weights were given"
            exit 2
        end
        alternatives[parts[0]] = values
    end
end

# Determine max and mins
for i in 0..columns.length - 1
    alternatives.each do |_, arr|
        if columns[i].min == nil || columns[i].min > arr[i]
            columns[i].min = arr[i]
        end

        if columns[i].max == nil || columns[i].max < arr[i]
            columns[i].max = arr[i]
        end
    end
end

# Do the math and print results
total_score = columns.inject(0) {|sum,x| sum += x.weight}

puts "Scores: (out of #{total_score} possible points)"

alternatives.each do |name, arr|
    score = 0
    for i in 0..columns.length - 1  do
        interpolated = (linear_interpolate(columns[i].min, columns[i].max, arr[i]))
        interpolated = 1 - interpolated if columns[i].negate
        score += interpolated * columns[i].weight
    end
    puts "#{name}: #{score.round(3)}"
end