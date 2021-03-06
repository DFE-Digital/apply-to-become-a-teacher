require 'rails_helper'

RSpec.describe Hesa::Disability do
  describe '.all' do
    it 'returns a list of HESA disability structs' do
      disability_values = described_class.all

      expect(disability_values.size).to eq 10

      deaf = disability_values.find { |e| e.hesa_code == '57' }

      expect(deaf.hesa_code).to eq '57'
      expect(deaf.value).to eq HesaDisabilityValues::DEAF
    end
  end

  describe '.find' do
    context 'given a valid value' do
      it 'returns the matching struct' do
        result = described_class.find('Deaf')

        expect(result.value).to eq HesaDisabilityValues::DEAF
        expect(result.hesa_code).to eq '57'
      end
    end

    context 'given an unrecognised value' do
      it 'returns nil' do
        result = described_class.find('Unrecognised disability')

        expect(result.value).to eq HesaDisabilityValues::OTHER
        expect(result.hesa_code).to eq '96'
      end
    end
  end

  describe '.convert_to_hesa_value' do
    context 'given a known disability' do
      it 'returns the matching hesa value' do
        result = described_class.convert_to_hesa_value('Social or communication impairment')

        expect(result).to eq HesaDisabilityValues::SOCIAL_OR_COMMUNICATION
      end
    end

    context 'given an unknown disability' do
      it 'returns nil' do
        result = described_class.convert_to_hesa_value('unrecognised disability')

        expect(result).to eq 'A disability, impairment or medical condition that is not listed above'
      end
    end
  end
end
