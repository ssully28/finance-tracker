class Stock < ApplicationRecord

  # Use 'self.' to make it a class method
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key], 
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    # client.post('ref-data/isin', isin: ['US0378331005'], token: 'secret_token') # [{'exchange' => 'NAS', ..., 'symbol' => 'AAPL'}, {'exchange' => 'ETR', ..., 'symbol' => 'APC-GY']

    begin
      new(
        ticker: ticker_symbol, 
        name: client.company(ticker_symbol).company_name, 
        last_price: client.price(ticker_symbol)
        )
    rescue => exception
      return nil
    end

  end
end
