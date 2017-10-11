class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @count = increment_count
    @count_message = "You have visited the index #{@count} times since adding an item to the cart!" if session[:counter] >= 5
  end

private

  def increment_count
    session[:counter] ||= 0
    session[:counter] += 1
  end

end
