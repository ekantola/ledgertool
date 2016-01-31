require File.dirname(__FILE__) + '/../test_helper'
require 'chart_controller'

# Re-raise errors caught by the controller.
class ChartController; def rescue_action(e) raise e end; end

class ChartControllerTest < Test::Unit::TestCase
  fixtures :chart

  def setup
    @controller = ChartController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = charts(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:charts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:chart)
    assert assigns(:chart).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:chart)
  end

  def test_create
    num_charts = Chart.count

    post :create, :chart => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_charts + 1, Chart.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:chart)
    assert assigns(:chart).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Chart.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Chart.find(@first_id)
    }
  end
end
