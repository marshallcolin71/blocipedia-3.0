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
      scope
    end
  end
end
