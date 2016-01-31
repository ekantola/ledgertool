class ChartController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @chart_pages, @charts = paginate :charts, :per_page => 30
  end

  def show
    @chart = Chart.find(params[:id])
  end

  def new
    @chart = Chart.new
  end

  def create
    @chart = Chart.new(params[:chart])
    if @chart.save
      flash[:notice] = 'Chart was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @chart = Chart.find(params[:id])
  end

  def update
    @chart = Chart.find(params[:id])
    if @chart.update_attributes(params[:chart])
      flash[:notice] = 'Chart was successfully updated.'
      redirect_to :action => 'show', :id => @chart
    else
      render :action => 'edit'
    end
  end

  def destroy
    Chart.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
