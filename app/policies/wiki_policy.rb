class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

    def initialize(user, wiki)
      @user = user
      @wiki = wiki
    end

    def index?
      true
    end

    def show?
      true
    end

    def create?
      user.present?
      unless (@wiki.private == false) || current_user.premium? || current_user.admin?
    end

    def new?
      create?
    end

    def update?
      user.present? && user.admin?
      user.present? && user == wiki.user
      unless (@wiki.private == false) || current_user.premium? || current_user.admin?
    end

    def edit?
      update?
    end

    def destroy?
      user && user.admin? || wiki.user == user
    end

    def scope
      Pundit.policy_scope!(user, record.class)
    end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.nil?
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if wiki.private == false
            wikis << wiki
          end
        end
      elsif user.admin?
        wikis = scope.all
      elsif user.premium?
        all_wikis = scope.all
        wikis = []
        collaborators = []
        all_wikis.each do |wiki|
          wiki.collaborators.each do |collaborator|
            collaborators << collaborator.email
          end
          if wiki.private == false ||wiki.user == user || collaborators.include?(user.email)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all 
        wikis = []
        collaborators = []
        all_wikis.each do |wiki|
          wiki.collaborators.each do |collaborator|
            collaborators << collaborator.email
          end
          if wiki.private == false || collaborators.include?(user.email)
            wikis << wiki
          end
        end
      end
      wikis
    end

  end

end
