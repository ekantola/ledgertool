require File.dirname(__FILE__) + '/../test_helper'
require 'acc_trans_controller'

# Re-raise errors caught by the controller.
class AccTransController; def rescue_action(e) raise e end; end

class AccTransControllerTest < Test::Unit::TestCase
  fixtures :acc_trans

  def setup
    @controller = AccTransController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = acc_trans(:first).id
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

    assert_not_nil assigns(:acc_trans)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:acc_trans)
    assert assigns(:acc_trans).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:acc_trans)
  end

  def test_create
    num_acc_trans = AccTrans.count

    post :create, :acc_trans => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_acc_trans + 1, AccTrans.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:acc_trans)
    assert assigns(:acc_trans).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      AccTrans.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      AccTrans.find(@first_id)
    }
  end
end
