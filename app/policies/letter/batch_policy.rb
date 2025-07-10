class Letter::BatchPolicy < ApplicationPolicy
  def index? = user.present?

  def show? = user.present?

  def new? = user.present?

  def create? = user.present?

  def edit? = user.present?

  alias_method :update?, :edit?

  def destroy? = user.admin?

  def map_fields? = user.present?

  alias_method :set_mapping?, :map_fields?
  alias_method :process_form?, :map_fields?
  alias_method :process_batch?, :map_fields?
  alias_method :mark_printed?, :update?
  alias_method :mark_mailed?, :mark_printed?

  alias_method :update_costs?, :show?

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user.present?
        scope.where(user: user)
      else
        scope.none
      end
    end
  end
end
