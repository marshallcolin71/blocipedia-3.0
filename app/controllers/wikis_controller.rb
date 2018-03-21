class WikisController < ApplicationController

  def index
    @user = User.find_by(id: session[:user_id])
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]

    if @wiki.save
      flash[:notice] = 'You have successfully created a new wiki.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error while creating your wiki. Please try again.'
      render :new
    end
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]

    if @wiki.save
     flash[:notice] = 'You have successfully updated your wiki.'
     redirect_to @wiki
    else
     flash.now[:alert] = 'There was an error updating your wiki. Please try again.'
     render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was successfully deleted"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error while deleting your wiki. Please try again"
      render :show
    end
  end
  
end