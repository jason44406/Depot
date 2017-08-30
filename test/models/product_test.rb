require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test "the truth" do
    assert true
  end

  test "product attributes must not be empty" do
    p = Product.new
    assert p.invalid?                   # True - should be invalid.
    assert p.errors[:title].any?        # True - should have an error.
    assert p.errors[:description].any?  # True - should have an error.
    assert p.errors[:price].any?        # True - should have an error.
    assert p.errors[:image_url].any?    # True - should have an error.
  end

  test "product price must be a positive number" do
    p = Product.new(title:       "My Test Title",
                    description: "My test description.",
                    image_url:   'MyTestImage.png')
    p.price = -1
    assert p.invalid? # Should return true - price is invalid; cannot be negative.
    assert_equal ["must be greater than or equal to 0.01"], p.errors[:price] # Should populate the errors array correctly.

    p.price = 0
    assert p.invalid? # Should return true - price is invalid, cannot be zero.
    assert_equal ["must be greater than or equal to 0.01"], p.errors[:price] # Should populate the errors array correctly.

    p.price = 1
    assert p.valid? # Should return true - price is valid; must be positive.
  end

  def new_product(image_url)
    p = Product.new(title:       "My Test Title",
                    description: "My test description.",
                    price:       1,
                    image_url:   image_url)
  end

  test "image url" do
    # These should be ok:
    ok = %w{ a.gif a.jpg a.png A.JPG A.Jpg http://a.b.c/x/y/z/a.gif }
    # These should fail.
    bad = %w{ b.doc b.gif/dir b.gif.html b.gif.. b }

    # Test the ok filenames
    ok.each do |n|
      assert new_product(n).valid?, "#{@n} shouldn't be invalid"
    end

    # Test the bad filenames
    bad.each do |n|
      assert new_product(n).invalid?, "#{n} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    # This is using the products.yml in fixtures.  The fixtures record can be accessed as below:
    p = Product.new(title:       products(:ruby).title,
                    description: products(:ruby).description,
                    price:       products(:ruby).price,
                    image_url:   products(:ruby).image_url)
    assert p.invalid? # Should be invalid because the fixtures were all loaded when this is run.  This additional instansiation re-uses an existing name.
    assert_equal ["has already been taken"], p.errors[:title]
    # Code to instead use the built-in error message table instead of hardcoding the message text as above.
    assert_equal [I18n.translate('errors.messages.taken')], p.errors[:title]
  end

  test "product title must be ten characters or more" do
    p = Product.new(title:       "More Than Ten Characters",
                    description: products(:ruby).description,
                    price:       products(:ruby).price,
                    image_url:   products(:ruby).image_url)
    assert p.valid?
    p.title = "9; Not 10"
    assert p.invalid?
    assert_equal [I18n.translate('errors.messages.too_short', :count=>10)], p.errors[:title]
  end

end
