class Column

    attr_accessor :weight
    attr_accessor :negate
    attr_accessor :max
    attr_accessor :min
    def initialize(weight, negate = false)
        @max = nil
        @min = nil
        @negate = negate
        @weight = weight
    end
end