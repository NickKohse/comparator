module Helpers
    def is_number(string)
        true if Float(string) rescue false
    end

    def linear_interpolate(min, max, x)
        return 1 if max == min
        return (x - min) / (max - min)
    end
end