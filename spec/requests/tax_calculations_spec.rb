require 'rails_helper'

RSpec.describe 'Tax calculations', type: :request do
  describe 'POST /tax_calculations' do
    context 'with valid income' do
      it 'displays the calculated tax and effective tax rate' do
        post '/tax_calculations', params: { income: '35000' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('NZ$5,033.00')
        expect(response.body).to include('14.38%')
      end
    end

    context 'with zero income' do
      it 'displays zero tax' do
        post '/tax_calculations', params: { income: '0' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('NZ$0.00')
        expect(response.body).to include('0.00%')
      end
    end

    context 'with negative income' do
      it 'returns an appropriate error message' do
        post '/tax_calculations', params: { income: '-100' }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('Income cannot be negative')
      end
    end

    context 'with missing income' do
      it 'returns an appropriate error message' do
        post '/tax_calculations', params: {}

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('Income must be a valid number')
      end
    end

    context 'with invalid income' do
      it 'returns unprocessable content satus' do
        post '/tax_calculations', params: { income: 'invalid' }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
