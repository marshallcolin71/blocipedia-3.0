class WikisController < ApplicationController

  def index
    @user = current_user
    @wikis = policy_scope(Wiki)
    authorize @wikis
  end

  def show
    @wiki = Wiki.find(params[:id])
    if current_user.present?
      collaborators = []
      @wiki.collaborators.each do |collaborator|
        collaborators << collaborator.email
      end
      unless (@wiki.private == false) || @wiki.user == current_user || collaborators.include?(current_user.email) || current_user.admin?
        flash[:alert] = "You are not authorized to view this wiki"
        redirect_to new_charge_path
      end
    else
      flash[:alert] = "You are not authorized to view this wiki"
      redirect_to new_charge_path
    end
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki

    if @wiki.save
      @wiki.collaborators = Collaborator.update_collaborators(params[:wiki][:collaborators])
      flash[:notice] = 'You have successfully created a new wiki.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error while creating your wiki. Please try again.'
      render :new
    end
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki

    if @wiki.save && (@wiki.user == current_user || current_user == admin?)
      @wiki.collaborators = Collaborator.update_collaborators(params[:wiki][:collaborators])
      flash[:notice] = "Wiki was updated successfully"
      redirect_to @wiki
    elsif @wiki.save
      flash[:notice] = "Wiki was updated successfully"
      redirect_to @wiki
    else
     flash.now[:alert] = 'There was an error updating your wiki. Please try again.'
     render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @wiki.destroy

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was successfully deleted"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error while deleting your wiki. Please try again"
      render :show
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action"
    redirect_to(new_user_session_path)
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
