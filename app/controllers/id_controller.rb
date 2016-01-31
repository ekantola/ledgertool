class IdController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @id_pages, @ids = paginate :ids, :per_page => 10
  end

  def show
    @id = Id.find(params[:id])
  end

  def new
    @id = Id.new
  end

  def create
    @id = Id.new(params[:id])
    if @id.save
      flash[:notice] = 'Id was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @id = Id.find(params[:id])
  end

  def update
    @id = Id.find(params[:id])
    if @id.update_attributes(params[:id])
      flash[:notice] = 'Id was successfully updated.'
      redirect_to :action => 'show', :id => @id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Id.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
