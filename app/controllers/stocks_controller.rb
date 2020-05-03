class StocksController < ApplicationController


  def search

    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        # Here we were just rendering the html file:
        # render 'users/my_portfolio'
        
        # Now we're using ajax so we'll have to 'respond to'
        # a js partial instead:
        respond_to do |format|
          format.js { render partial: 'users/result'}
        end
      else
        # Same change necessary here:
        # redirect_to my_portfolio_path
        # Note add the '.now' to flash to avoid persistant flash messages!
        respond_to do |format|
          flash.now[:alert] = "Could not find that symbol"
          format.js { render partial: 'users/result'}
        end
      end

    else
      # And here...
      # flash[:alert] = "Enter a symbol to search"
      # redirect_to my_portfolio_path
      respond_to do |format|
        flash.now[:alert] = "Enter a symbol to search"
        format.js { render partial: 'users/result'}
      end
    end
  end
end