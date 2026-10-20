require 'rails_helper'

RSpec.describe TaxCalculator do
  describe '#calculate' do
    describe 'happy path test cases' do
      [
        { income: '10000', expected_total_tax: '1050', expected_effective_rate: '10.50' },
        { income: '35000', expected_total_tax: '5033', expected_effective_rate: '14.38' },
        { income: '100000', expected_total_tax: '22877.50', expected_effective_rate: '22.88' },
        { income: '220000', expected_total_tax: '64877.50', expected_effective_rate: '29.49' }
      ].each do |data|
        it "calculates tax $#{data[:expected_total_tax]} and tax rate #{data[:expected_effective_rate]}% for an income of $#{data[:income]}" do
          response = TaxCalculator.new(data[:income]).calculate
          expect(response[:total_tax]).to eq(BigDecimal(data[:expected_total_tax]))
          expect(response[:effective_tax_rate]).to eq(BigDecimal(data[:expected_effective_rate]))
        end
      end
    end

    describe 'tax bracket boundaries' do
      [
        { income: '0', expected_total_tax: '0', expected_effective_rate: '0' },
        { income: '15599', expected_total_tax: '1637.90', expected_effective_rate: '10.50' },
        { income: '15600', expected_total_tax: '1638.00', expected_effective_rate: '10.50' },
        { income: '15601', expected_total_tax: '1638.18', expected_effective_rate: '10.50' },
        { income: '53499', expected_total_tax: '8270.33', expected_effective_rate: '15.46' },
        { income: '53500', expected_total_tax: '8270.50', expected_effective_rate: '15.46' },
        { income: '53501', expected_total_tax: '8270.80', expected_effective_rate: '15.46' },
        { income: '78099', expected_total_tax: '15650.20', expected_effective_rate: '20.04' },
        { income: '78100', expected_total_tax: '15650.50', expected_effective_rate: '20.04' },
        { income: '78101', expected_total_tax: '15650.83', expected_effective_rate: '20.04' },
        { income: '179999', expected_total_tax: '49277.17', expected_effective_rate: '27.38' },
        { income: '180000', expected_total_tax: '49277.50', expected_effective_rate: '27.38' },
        { income: '180001', expected_total_tax: '49277.89', expected_effective_rate: '27.38' }
      ].each do |data|
        it "calculates tax $#{data[:expected_total_tax]} and tax rate #{data[:expected_effective_rate]}% for an income of $#{data[:income]}" do
          response = TaxCalculator.new(data[:income]).calculate
          expect(response[:total_tax]).to eq(BigDecimal(data[:expected_total_tax]))
          expect(response[:effective_tax_rate]).to eq(BigDecimal(data[:expected_effective_rate]))
        end
      end
    end

    describe 'rounding' do
      it 'rounds calculated tax to two decimal places' do
        result = TaxCalculator.new('10000.05').calculate

        expect(result[:total_tax]).to eq(BigDecimal('1050.01'))
        expect(result[:effective_tax_rate]).to eq(BigDecimal('10.50'))
      end
    end

    describe 'failure cases' do
      context 'when income is not a valid number' do
        it 'raises an ArgumentError' do
          invalid_incomes = [ 'ten grand', '$10,000', '10000.abc' ]
          invalid_incomes.each do |income|
            expect { TaxCalculator.new(income) }.to raise_error(ArgumentError, 'Income must be a valid number')
          end
        end
      end

      context 'when income is missing or empty' do
        it 'raises an ArgumentError' do
          [ nil, '', ' ' ].each do |income|
            expect { TaxCalculator.new(income) }.to raise_error(ArgumentError, 'Income must be a valid number')
          end
        end
      end

      context 'when income is Infinity or NaN' do
        it 'raises an ArgumentError' do
          invalid_incomes = [ 'Infinity', 'NaN' ]
          invalid_incomes.each do |income|
            expect { TaxCalculator.new(income) }.to raise_error(ArgumentError, 'Income must be finite')
          end
        end
      end

      context 'when income is negative' do
        it 'raises an ArgumentError' do
          invalid_incomes = [ '-100', '-100.01', '-0.01' ]
          invalid_incomes.each do |income|
            expect { TaxCalculator.new(income) }.to raise_error(ArgumentError, 'Income cannot be negative')
          end
        end
      end
    end
  end
end
