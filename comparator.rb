#!/usr/bin/env ruby
require_relative 'helpers'

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
weights = Array.new

File.read(ARGV[0]).each_line do |line|
    parts = line.split(',')
    if !read_legend
        for i in 1..parts.length - 1 do
            weight = parts[i].split('[')[1].scan(/\d+/).first
            if weight == nil
                puts "Weight at index #{i} improperly specified"
                exit 2
            end
            weights.push(weight.to_i)
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
        if values.length != weights.length
            puts "Alternative #{parts[0]} has #{values.length} values specified, but #{weights.length} weights were given"
            exit 2
        end
        alternatives[parts[0]] = values
    end
end

# Determine max and mins
maxs = Array.new
mins = Array.new
for i in 0..weights.length - 1 do
    min = nil
    max = nil
    alternatives.each do |_, arr|
        if min == nil || min > arr[i]
            min = arr[i]
        end

        if max == nil || max < arr[i]
            max = arr[i]
        end
    end
    maxs.push(max)
    mins.push(min)
end

# Do the math and print results

puts "Scores: (out of #{weights.reduce(:+)} possible points)"

alternatives.each do |name, arr|
    score = 0
    for i in 0..weights.length - 1  do
        score += (linear_interpolate(mins[i], maxs[i], arr[i]) * weights[i])
    end
    puts "#{name}: #{score.round(3)}"
end