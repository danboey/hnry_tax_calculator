class TaxCalculator
  TAX_BRACKETS = [
    { upper_limit: 15_600, rate: BigDecimal("0.105") },
    { upper_limit: 53_500, rate: BigDecimal("0.175") },
    { upper_limit: 78_100, rate: BigDecimal("0.3") },
    { upper_limit: 180_000, rate: BigDecimal("0.33") },
    { upper_limit: nil, rate: BigDecimal("0.39") }
  ].each(&:freeze).freeze

  # Validate at the service layer so the calculator can be used independently of the controller
  def initialize(income)
    @income = parse_income(income)
    validate!
  end

  def calculate
    return { total_tax: BigDecimal("0"), effective_tax_rate: BigDecimal("0") } if @income.zero?

    total_tax = BigDecimal("0")
    lower_limit = 0

    TAX_BRACKETS.each do |bracket|
      upper_limit = bracket[:upper_limit] || @income

      taxable_income = [ @income, upper_limit ].min - lower_limit
      break if taxable_income <= 0

      total_tax += taxable_income * bracket[:rate]
      lower_limit = upper_limit
    end

    total_tax = total_tax.round(2)

    effective_tax_rate = ((total_tax / @income) * 100).round(2)

    { total_tax: total_tax, effective_tax_rate: effective_tax_rate }
  end


  private

  def parse_income(income)
    BigDecimal(income.to_s)
  rescue ArgumentError
    raise ArgumentError, "Income must be a valid number"
  end

  def validate!
    raise ArgumentError, "Income must be finite" unless @income.finite?
    raise ArgumentError, "Income cannot be negative" if @income.negative?
  end
end
