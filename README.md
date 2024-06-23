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

## Observation Matchers
- we instead use block of codes to do it, example:
```bash
array = []
expect {array << 1}.to change(array, :empty?).from(true).to(false)
# calls :empty? before and after the block

expect do
    bob.first_name  = 'Robert'
    bob.last_name  = 'Smith'
end.to change(bob, :full_name).from('Bob Smith').to('Robert Smith')

x = 10
expect { x+=1 }.to change{x}.from(10).to(1)
expect {x+=1}. to change{x % 3}.from(2).to(0)
```
- we can observe errors as well other than observing values, example:
```bash
expect {customer.delete}.to raise_error
expect {customer.delete}.to raise_exception

expect {1/10}.to raise_error(ZeroDivisionError)
expect {1/10}.to raise_error.with_message("divided by 0")
expect {1/10}.to raise_error.with_message(/divided/)
```
- other than that, we can observe output as well, example:
```bash
expect {print "Hello"}.to output.to_stdout
expect {print "Hello"}.to output("Hello").to_stdout
expect {print "Hello"}.to output(/ll/).to_stdout
expect {warn "Hello"}.to output(/llo/).to_stderr
```

## Compund expectation
- example of complex expectation:
```bash
s = 'Lynda'
expect(s).to start_with('L').and end_with('a')
expect(s.length).to be_even.or be < 6
expect(s).to start_with('L') & end_with('a')
expect(s.length).to be_even | be < 6

array = [1,2,3]
expect(array).to all(be < 5)
expect(@items).to all(be_visible & be_in_stock)
```
- example of noun-phrase aliases for matchers
![noun-phrase](noun-phrase.png)

# Using Hooks
- with the benefits of DRY
- use instance variables to make objects available to examples
- **customer** is local variable and will not be available
- **@customer** is an instance variable and will be available
- before hooks
- after hooks
- around hooks
- example usage of hooks:
![alt text](before-hooks.png)

# Using the let method
- The let method in RSpec is used to define **memoized** helper methods. It's a way to create variables that are **lazily evaluated**, meaning the value is calculated the first time it is accessed, and that value is **cached** for subsequent access within the same example.
- example:
```bash
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def adult?
    @age >= 18
  end
end

RSpec.describe Person do
  let(:person) { Person.new("Alice", 25) }

  it 'checks if person is an adult' do
    expect(person.adult?).to be true
  end

  it 'checks the name of the person' do
    expect(person.name).to eq("Alice")
  end

  it 'checks the age of the person' do
    expect(person.age).to eq(25)
  end
end
```