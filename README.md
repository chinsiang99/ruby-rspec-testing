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