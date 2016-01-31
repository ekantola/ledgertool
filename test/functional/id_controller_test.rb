require File.dirname(__FILE__) + '/../test_helper'
require 'id_controller'

# Re-raise errors caught by the controller.
class IdController; def rescue_action(e) raise e end; end

class IdControllerTest < Test::Unit::TestCase
  fixtures :id

  def setup
    @controller = IdController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = ids(:first).id
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

    assert_not_nil assigns(:ids)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:id)
    assert assigns(:id).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:id)
  end

  def test_create
    num_ids = Id.count

    post :create, :id => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_ids + 1, Id.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:id)
    assert assigns(:id).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Id.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Id.find(@first_id)
    }
  end
end
