class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :user, through: :user_stocks

  validates :name, :ticker, presence: true

  # Use 'self.' to make it a class method
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key], 
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    # client.post('ref-data/isin', isin: ['US0378331005'], token: 'secret_token') # [{'exchange' => 'NAS', ..., 'symbol' => 'AAPL'}, {'exchange' => 'ETR', ..., 'symbol' => 'APC-GY']

    begin
      new(
        ticker: ticker_symbol.upcase, 
        name: client.company(ticker_symbol).company_name, 
        last_price: client.price(ticker_symbol)
        )
    rescue => exception
      return nil
    end

  end

  def self.check_db(ticker_symbol)
    ticker_symbol.upcase!
    where(ticker: ticker_symbol).first
  end
end
