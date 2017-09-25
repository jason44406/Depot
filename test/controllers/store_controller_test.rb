require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select '#columns #side a', minimum: 4 #This looks for an element named 'a' that's contained in an element with an id with a value of 'side', which is contained within an element with an id of 'columns'
    assert_select '#main .entry', 3 #Three elements from fixtures.  Would need to change if there are more added to fixtures.
    assert_select 'h3', 'Programming Ruby 1.9'
    assert_select '.price', /\$[,\d]+\.\d\d/ #lol wut?  This makes sure the price is formatted correctly.  $n.nn
    assert_select '#columns #side #time a', 1
  end

end
