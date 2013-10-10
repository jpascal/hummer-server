class Ability
  include CanCan::Ability
  def initialize(user)
    can [:read,:search,:paste,:delete,:create], Suite
    can [:read,:paste], Case
  end
end
