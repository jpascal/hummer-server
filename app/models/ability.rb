class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    can [:read,:search,:paste], Suite
    can [:read,:paste], Case
    unless user.new_record? # Registered user
      can [:delete,:create], Suite
      can :track, Case
    end
  end
end
