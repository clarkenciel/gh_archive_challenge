require_relative './builder_helper'

RSpec.describe GHRepo::Concerns do
  before :all do
    Car = Struct.new(:wheels)
  end

  before :each do
    @concerns = GHRepo::Concerns.new
  end

  it 'can add concerns' do
    @concerns.add(:dog, nil)
    expect(@concerns.keys).to include(:dog)
  end

  it 'yields enumerators' do
    concerns = @concerns.each
    expect(concerns).to be_a(Enumerator)
  end

  it 'can add aliases' do
    @concerns.add(:dog, nil)
    @concerns.add_aliases(:dog, [:pupper, :doggo])
    _, hash = @concerns.each.find {|k,_| k == :dog}
    expect(hash[:aliases]).to(
      eq(Set.new([:pupper, :doggo]))
    )
  end

  it 'can build on an object' do
    car = Car.new
    @concerns.add(:wheels, nil)
    @concerns.build_on(car, {wheels: 4})
    expect(car.wheels).to eq(4)
  end

  it 'runs callbacks on build' do
    car = Car.new
    @concerns.add(:wheels, ->(x) { x * 2 })
    @concerns.build_on(car, {wheels: 4})
    expect(car.wheels).to eq(8)
  end
end
