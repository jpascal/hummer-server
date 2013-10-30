class PasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  attr_accessor :password, :password_confirmation

  validates_presence_of :password, :password_confirmation
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    if valid?
      @user.password = password
      @user.password_confirmation = password_confirmation
      @user.save!
      true
    else
      false
    end
  end
end