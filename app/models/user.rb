class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit?
    stocks.count < 30
  end

  def stock_already_tracked?(ticker_symbol)
    ticker_symbol.upcase!
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker_symbol)
    ticker_symbol.upcase!
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
end
