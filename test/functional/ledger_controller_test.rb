require File.dirname(__FILE__) + '/../test_helper'
require 'ledger_controller'

# Re-raise errors caught by the controller.
class LedgerController; def rescue_action(e) raise e end; end

class LedgerControllerTest < Test::Unit::TestCase
  def setup
    @controller = LedgerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
