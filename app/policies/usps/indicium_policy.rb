class USPS::IndiciumPolicy < ApplicationPolicy
  def create?
    user&.can_use_indicia?
  end

  def index?
    user_is_admin
  end

  def show?
    user_is_admin
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
