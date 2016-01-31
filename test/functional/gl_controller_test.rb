require File.dirname(__FILE__) + '/../test_helper'
require 'gl_controller'

# Re-raise errors caught by the controller.
class GlController; def rescue_action(e) raise e end; end

class GlControllerTest < Test::Unit::TestCase
  fixtures :gl

  def setup
    @controller = GlController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = gls(:first).id
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

    assert_not_nil assigns(:gls)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:gl)
    assert assigns(:gl).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:gl)
  end

  def test_create
    num_gls = Gl.count

    post :create, :gl => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_gls + 1, Gl.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:gl)
    assert assigns(:gl).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Gl.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Gl.find(@first_id)
    }
  end
end
