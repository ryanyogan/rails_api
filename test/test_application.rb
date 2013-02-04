# rulers/test/test_application.rb

require_relative "test_helper"

class TestApp < Rulers::Application
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_array_sum_addition
    assert [].respond_to?(:sum)
    assert [1,2].sum == 3
  end
end
