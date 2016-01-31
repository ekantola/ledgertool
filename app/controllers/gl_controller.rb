class GlController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @gl_pages, @gls = paginate :gls, :per_page => 30
  end

  def show
    @gl = Gl.find(params[:id])
  end

  def new
    @gl = Gl.new
  end

  def create
    @gl = Gl.new(params[:gl])
    if @gl.save
      flash[:notice] = 'Gl was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @gl = Gl.find(params[:id])
  end

  def update
    @gl = Gl.find(params[:id])
    if @gl.update_attributes(params[:gl])
      flash[:notice] = 'Gl was successfully updated.'
      redirect_to :action => 'show', :id => @gl
    else
      render :action => 'edit'
    end
  end

  def destroy
    Gl.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
