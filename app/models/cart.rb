class Cart < ApplicationRecord

  has_many :line_items, dependent: destroy # If we destroy a cart, we will also destroy the associated line items
end
