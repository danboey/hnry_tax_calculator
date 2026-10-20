# NZ Income Tax Calculator

Ruby on Rails app for calculating income tax.

## Requirements

- Ruby 3.4.4
- Rails 8
- Bundler

No database required.

## Setup

Clone the repo and install gems:

```bash
bundle install
```

Start the Rails server:

```bash
bin/rails server
```

Open http://localhost:3000 in browser.

## Running Tests

RSpec for testing.

```bash
bundle exec rspec
```

Tests cover:

- The four test cases provided in the assessment.
- Tax bracket boundaries.
- Invalid, missing, negative and non-finite incomes.
- Rounding.
- HTTP responses and rendered results.

## Implementation

The app uses a `TaxCalculator` service class for the calculation logic and input validation.

### Design Decisions

- **Tax bracket:** Brackets are defined as a frozen constant, separate from the calculation logic. This allows rates/thresholds to be updated without modifying the algorithm.
- **Precision:** `BigDecimal` used to avoid floating-point precision issues. The final tax amount is rounded to two decimal places.
- **Validation:** Input validation occurs within the service so it can be used independently of the controller.

## Assumptions and Limitations

- The calculator uses New Zealand income tax brackets specified in the assessment.
- Income is assumed to be annual income in NZD.
- The calculation algorithm can accommodate alternative tax brackets assuming they're in the same format.
- The app only supports only New Zealand's specified 2025 tax rates.
- There's quite a bit of unnecessary Rails boilerplate that I haven't removed due to time constraints.

## AI Assistance
- **/app/views/tax_calculations/index.html.erb**: fully AI generated due to time constraints, and also as I'm not a frontend engineer.
- **/spec/requsts/tax_calculations_spec.rb**: aside from the first test I used AI to generate the rest, also due to time constraints
- **README.md**: for formatting, my markdown is rusty