class Car

    # attr_accessor creates getter and setter methods for make, year, and color attributes
    attr_accessor :make, :year, :color

    # attr_reader creates a getter method for wheels attribute
    attr_reader :wheels

    # attr_writer creates a setter method for doors attribute
    attr_writer :doors

    def initialize(options={})
        self.make = options[:make] || 'Volvo'
        self.year = (options[:year] || 2007).to_i
        self.color = options[:color] || 'unknown'
        @wheels = 4 # note that we do not use self.wheels = 4 here, it is because of it is not a setter method
    end

    def self.colors
        ['blue', 'black', 'red', 'green']
    end

    def full_name
        "#{self.year.to_s} #{self.make} (#{self.color})"
    end
end
