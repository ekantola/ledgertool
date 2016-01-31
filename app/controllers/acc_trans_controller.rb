class AccTransController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @acc_trans_pages, @acc_trans = paginate :acc_trans, :per_page => 30
  end

  def show
    @acc_trans = AccTrans.find(params[:id])
  end

  def new
    @acc_trans = AccTrans.new
  end

  def create
    @acc_trans = AccTrans.new(params[:acc_trans])
    if @acc_trans.save
      flash[:notice] = 'AccTrans was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @acc_trans = AccTrans.find(params[:id])
  end

  def update
    @acc_trans = AccTrans.find(params[:id])
    if @acc_trans.update_attributes(params[:acc_trans])
      flash[:notice] = 'AccTrans was successfully updated.'
      redirect_to :action => 'show', :id => @acc_trans
    else
      render :action => 'edit'
    end
  end

  def destroy
    AccTrans.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
