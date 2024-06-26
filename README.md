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

# Testing Efficiency

## Using Hooks
- with the benefits of DRY
- use instance variables to make objects available to examples
- **customer** is local variable and will not be available
- **@customer** is an instance variable and will be available
- before hooks
- after hooks
- around hooks
- example usage of hooks:
![alt text](before-hooks.png)

## Using the let method
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

## Setting a subject
- The let and subject methods in RSpec are both used to define memoized helper methods, but they serve slightly different purposes and have different conventions for use. Here's a detailed comparison to help understand their differences, benefits, and appropriate use cases.

### let
Purpose: Defines a memoized helper method for auxiliary objects or values used in tests.
Evaluation: Lazily evaluated—computed the first time it is accessed in a test, and the value is cached for the rest of the test.
Naming: Typically used for objects or values that support the main object under test.
```bash
RSpec.describe Person do
  let(:young_person) { Person.new("Bob", 16) }

  it 'returns false for a minor' do
    expect(young_person.adult?).to be false
  end
end
```

### subject
Purpose: Defines the primary object under test. This is the object that the example group is focused on.
Evaluation: Lazily evaluated, like let, but can also be eagerly evaluated with subject!.
Naming: Usually named to reflect the primary focus of the tests. If unnamed, it defaults to an instance of the described class.
```bash
RSpec.describe Person do
  subject(:person) { Person.new("Alice", 25) }

  it 'has the correct name' do
    expect(person.name).to eq("Alice")
  end
end
```

### Key Differences
1. Primary vs. Auxiliary:
- subject: Used for the primary object under test.
- let: Used for auxiliary objects or values that support the tests.

2. Implicit Naming:
- subject: If unnamed, defaults to an instance of the described class.
- let: Always requires a name.

3. Contextual Meaning:
- subject: Indicates the main focus of the test.
- let: Provides support objects or values for the test.

- example of using them:
```bash
class Car
  attr_accessor :make, :model, :engine

  def initialize(make, model, engine)
    @make = make
    @model = model
    @engine = engine
  end
end

class Engine
end

RSpec.describe Car do
  subject(:car) { Car.new("Toyota", "Camry", engine) }
  let(:engine) { Engine.new }

  describe 'attributes' do
    it 'has the correct make' do
      expect(car.make).to eq("Toyota")
    end

    it 'has the correct model' do
      expect(car.model).to eq("Camry")
    end

    it 'has an engine' do
      expect(car.engine).to be(engine)
    end
  end
end
```

## Shared Examples
- Shared examples in RSpec allow you to define a set of tests that can be reused across multiple contexts or example groups. This is particularly useful when you have common behavior that you want to ensure across different classes or instances.

### Defining Shared Examples
You define shared examples using the RSpec.shared_examples method (or shared_examples_for), providing a name and a block of code containing the tests.

```bash
RSpec.shared_examples "a vehicle" do
  it "has wheels" do
    expect(subject.wheels).to be > 0
  end

  it "has an engine" do
    expect(subject).to respond_to(:engine)
  end
end
```

### Using Shared Examples
You include shared examples in your example groups using the include_examples or it_behaves_like methods.
```bash
class Car
  attr_accessor :wheels, :engine

  def initialize
    @wheels = 4
    @engine = "V8"
  end
end

RSpec.describe Car do
  subject { Car.new }

  it_behaves_like "a vehicle"
end
```

### Example Scenario
Let's say you have different types of vehicles (e.g., Car, Truck) that share some common behavior, such as having wheels and an engine. You can define shared examples to test this common behavior and then include these examples in the tests for both Car and Truck.

### Example with Parameters
- Shared examples can also take parameters to make them more flexible.
```bash
RSpec.shared_examples "a vehicle with parameters" do |wheels, engine_type|
  it "has the correct number of wheels" do
    expect(subject.wheels).to eq(wheels)
  end

  it "has the correct engine type" do
    expect(subject.engine).to eq(engine_type)
  end
end

RSpec.describe Car do
  subject { Car.new }

  include_examples "a vehicle with parameters", 4, "V8"
end

RSpec.describe Truck do
  subject { Truck.new }

  include_examples "a vehicle with parameters", 6, "Diesel"
end
```

# Test Doubles
- an object that stands in for another object
- similar to a stand-in or body double for an actor/actress
- doubles, mocks, stubs, fakes, spies, dummies

## Why use test doubles?
- real object is difficult or "expensive" to work with
- a simpler version will serve our purpose just as well
- responses are unpredictable
- having fixed, expected responses makes testing easier

## Definitions
- Double/mock: a simple object programmed with expectations and responses as preparations for the calls it will receive
- Stub: an instruction to an object to return a specific response to a method call

## Using Mocks and Stubs

- Mocks and stubs are fundamental concepts in testing, especially in behavior-driven development (BDD) frameworks like RSpec. They help isolate the code under test, making it easier to test specific behaviors without relying on real objects or external dependencies.

### Stubs
- Stubs are used to provide **predetermined responses** to **method calls**. They are useful when you want to isolate the behavior of the method you are testing from other methods or when interacting with external services or systems.

- Usage
1. Define a Stub: Use allow to define a stub.
2. Control Return Values: Specify what a method should return when it is called.
- example:
```bash
class User
  def initialize(name)
    @name = name
  end

  def greet
    "Hello, #{@name}"
  end

  def time_sensitive_greet
    if Time.now.hour < 12
      "Good morning, #{@name}"
    else
      "Good afternoon, #{@name}"
    end
  end
end

RSpec.describe User do
  let(:user) { User.new("Alice") }

  it 'greets the user' do
    expect(user.greet).to eq("Hello, Alice")
  end

  it 'greets the user based on time' do
    allow(Time).to receive(:now).and_return(Time.new(2024, 6, 21, 9, 0, 0)) # Stub the current time
    expect(user.time_sensitive_greet).to eq("Good morning, Alice")
  end
end
```

### Mocks
- Mocks are similar to stubs but with additional functionality. Mocks can also set expectations about method calls, such as how many times a method should be called and with what arguments. They are useful for verifying interactions between objects.

- Usage
1. Define a Mock: Use expect to define a mock.
2. Set Expectations: Specify how the object should be used in terms of method calls and arguments.

- example:
```bash
class Order
  def initialize(payment_gateway)
    @payment_gateway = payment_gateway
  end

  def place_order(amount)
    @payment_gateway.charge(amount)
  end
end

class PaymentGateway
  def charge(amount)
    # Implementation for charging the amount
  end
end

RSpec.describe Order do
  let(:payment_gateway) { instance_double("PaymentGateway") }
  let(:order) { Order.new(payment_gateway) }

  it 'charges the correct amount' do
    expect(payment_gateway).to receive(:charge).with(100)
    order.place_order(100)
  end
end
```

### combining mocks and stubs
```bash
class Order
  def initialize(payment_gateway)
    @payment_gateway = payment_gateway
  end

  def place_order(amount)
    if @payment_gateway.has_funds?(amount)
      @payment_gateway.charge(amount)
    else
      raise "Insufficient funds"
    end
  end
end

class PaymentGateway
  def has_funds?(amount)
    # Check for funds
  end

  def charge(amount)
    # Charge the amount
  end
end

RSpec.describe Order do
  let(:payment_gateway) { instance_double("PaymentGateway") }
  let(:order) { Order.new(payment_gateway) }

  it 'charges the amount if funds are available' do
    allow(payment_gateway).to receive(:has_funds?).with(100).and_return(true)
    expect(payment_gateway).to receive(:charge).with(100)
    order.place_order(100)
  end

  it 'raises an error if funds are not available' do
    allow(payment_gateway).to receive(:has_funds?).with(100).and_return(false)
    expect { order.place_order(100) }.to raise_error("Insufficient funds")
  end
end
```