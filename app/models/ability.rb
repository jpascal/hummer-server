class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    can [:read,:search,:paste], Suite
    can [:read,:paste], Case

    if not user.new_record? # Registered user
      can [:delete,:create], Suite
    end

  end
end
