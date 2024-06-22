# RSpec installation
> gem install rspec
> rspec --version
> rspec --help

# RSpec Configuration
- there are some configurations for RSpec, below are the configurations, left hand side is the default one
```bash
--no-color, --color
--format progress, --format documentation
--no-profile, --profile
--no-fail-fast, --fail-fast
--order defined, --order random
```
- Global: ~/.rspec => for ur computer
- Project: ./.rspec => project wise
- Local: ./.rspec-local => my configuration (override any settings in global and project)

# Basic Syntax of RSpec
- we can use this command line to initialize rspec:
> rspec --init
- example of a unit test:
```bash
describe 'Car' do
    it "allows reading for :wheels" do
        # expectations
    end

    describe '.colors' do
        it "returns an array of color names" do
            # expectations
            c = ['blue', 'black', 'red', 'green']
            expect(Car.colors).to match_array(c)
        end
    end
    # or we can group with
    context '.colors' do
        it "returns an array of color names" do
            # expectations
        end
    end
end
```

# RSpec Hierarchy
- fundamental structure of RSpec
![RSpec hierarchy](rspec-hierarchy.png)

# Running specs
> rspec 01.car_project/spec/car_spec.rb 

# Matchers in RSpec

## Equivalence matchers
- note that == is actually close enough, it is loosely equality, but for .eql, it has a stronger restriction - it is for value equality, and .equal is for indentity quality:
```bash
x = 1   #true

x == 1  # true
x == 1.0  # true
x == '1'  #false

x.eql?(1) # true
x.eql?(1.0) # false
x.eql?('1') # false

x = 'Lynda'
x == 'Lynda' # true
x.eql?('Lynda') # true
x.equal?('Lynda') # false
```

- common equivalence matchers:
```bash
x = 1
expect(x).to eq(1) # x == 1, most common
expect(x).to be == 1 # x == 1
expect(x).to eql(1) # x.eql?(1)
expect(x).to equal(1) # x.equal?(1), rare
expect(x).to be(1) # x.equal?(1)
```

## Truthiness Matchers
- we can use matchers like **to be_truthy** or to **be_falsy** to have testing matchers
- note that *truthy* and *falsy* is actually loosely equivalent
- if we want to be exact, we can use to be(true) or to be(false)
- we can specifically use **to be_nil** to check whether it is nil or not

## Numeric Comparison Matchers
- we can use to be > 99 or even to be eq(100)
- we can use to be_between(3, 5).inclusive or to be_between(3, 5).exclusive to specify a range
- we can use to be_within(5).of(10) => meaning that from 5 - 15 it will return true
- we can use (1..10).to cover(3) to check whether a range cover the value

## Collections Matchers
- there are a bunch of matchers to work with collections
- example: 
```bash
array = [1,2,3]
expect(array).to include(3)
expect(array).to include(2,3)
expect(array).to start_with(1)
expect(array).to end_with(3)

# match_array: same elements in any order
expect(array).to match_array([3,2,1])

# contain_exactly: uses individual args
expect(array).to contain_exactly(1,3,2)

string = 'Lydia'
expect(string).to include('Ly')
expect(string).to include('Ly', 'da')
expect(string).to start_with('Ly')
expect(string).to end_with('da')

hash = {:city => 'Dallas', :state => 'TX'}
expect(hash).to include(:city)
expect(hash).to include(:city, :state)
expect(hash).to include(:city => 'Dallas', :state => 'TX')
expect(hash).to include(:city => 'Dallas')
```

## Other useful matchers

### Regular Expression Matchers
- it only works with strings
```bash
string = 'Lydia'
expect(string).to match(/^L.a+$/)

# only work with string
expect('123').to match(/\d{3}/)
expect(123).not_to match(/\d{3}/)
```

### Object type Matcher
- **be_a / be_an**: Checks if an object is an instance of a class..
- **be_kind_of**: Checks if an object is an instance of a class or its subclass.

### Attributes Matcher
- **have_attributes**: Checks if an object has specified attributes with certain values.

### Satisfy Matcher
- The **satisfy** matcher in RSpec is a **flexible matcher** that allows you to pass a **custom block** to specify more complex or unique conditions that an object must meet. This matcher is particularly useful **when none of the built-in matchers quite fit your needs**.
- example:
```bash
RSpec.describe 'satisfy matcher' do
  it 'checks if a number is even and greater than 10' do
    expect(12).to satisfy { |value| value.even? && value > 10 }
  end
end
```

## Predicate Matchers
- all question mark methods can actually been used with matchers
- example:
    - expect(123).to be_integer => supposingly is 123.integer?
    - 123.nil?
- besides, we can match custom methods as well, example:
    - to be_visible