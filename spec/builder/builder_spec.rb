require_relative './builder_helper'

RSpec.describe GHRepo::Builder do
  context 'extended objects' do
    before :all do
      class Dog
        include GHRepo::Builder

        def initialize(**hash)
          build(hash)
        end
      end

      class GreatDane < Dog
        attribute(:size, aliases: [:height]) do |s|
          s.to_s + ' ft.'
        end

        attributes(:pointy_ears, :floppy_chops)
      end

      class StBernard < Dog
        builds_like(GreatDane)
        attribute(:keg)
      end
    end

    it 'produce objects that can be built' do
      gd = GreatDane.new(size: 10)
      expect(gd.height).to eq(gd.size)
      expect(gd.height).to eq('10 ft.')

      gd.build({ pointy_ears: true })
      expect(gd.pointy_ears).to be(true)

      gd.floppy_chops = true
      expect(gd.floppy_chops).to be(true)
    end

    it 'allows objects to be built like other objects' do
      sb = StBernard.new(size: 10, keg: 'empty')
      expect(sb.height).to eq(sb.size)
      expect(sb.height).to eq('10 ft.')
      expect(sb.keg).to eq('empty')

      sb.build({ pointy_ears: true })
      expect(sb.pointy_ears).to be(true)

      sb.floppy_chops = true
      expect(sb.floppy_chops).to be(true)

      sb.keg = 'full'
      expect(sb.keg).to eq('full')
    end
  end
end
