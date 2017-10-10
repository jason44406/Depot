require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    ## Add valid test date to pass validation from Chap7 IterB1.
    @update = {
      title:        'Lorem Ipsum',
      description:  'Wibbles are fun!',
      image_url:    'lorem.jpg',
      price:        0.01
    }
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: @update }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: @update }
    assert_redirected_to product_url(@product)
  end

  test "can't delete a product in cart" do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end

    assert_redirected_to products_url
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test "should show sidebar with time" do
    get products_url
    assert_select '#columns #side', 1 # Sidebar should be present
    assert_select '#columns #side a', minimum: 4 # Should be This looks for an element named 'a' that's contained in an element with an id with a value of 'side', which is contained within an element with an id of 'columns'
    assert_select '#columns #side #time a', 1
  end

  test "should show items in main" do
    get products_url
    assert_select 'tr', 3 #Three elements from fixtures.  Would need to change if there are more added to fixtures.
  end

end
