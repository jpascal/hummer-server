require 'securerandom'

class User < ActiveRecord::Base
  self.primary_key = :id
  validates :name, :length => { :minimum => 4 }

  has_many :suites, :readonly => true

  has_many :members, :dependent => :delete_all

  def projects
    Project.where("id IN (?) or private = ?", members.collect{|member| member.project_id},false)
  end

  has_many :projects, :through => :members
  has_many :bugs

  scope :actived, -> { where(:active => true) }

  paginates_per 20

  before_create do
    if User.count == 0
      self.admin = true
      self.active = true
    end
  end

  def api_token!
    update(:api_token => SecureRandom.hex(48))
  end

  validate :custom_validate
  def custom_validate
    if (self.admin_change == [true, false] or self.active_change == [true, false]) and User.where(:admin => true, :active => true).count == 1
      errors.add :base, "Can't uncheck admin/active for this user."
    end
    if self.password_confirmation.present? and self.password_confirmation != self.password
      errors.add :password, "doesn't match Password confirmation"
    end
  end

  acts_as_authentic do |config|
    config.login_field = :email
  end

  def ldap?
    self.dn.present?
  end

  def ldap= value
    if value
      self.ldap!
    else
      self.dn = nil
      self.save!
    end
  end

  def name= value
    self.attributes[:name] = value unless self.ldap?
  end

  def ldap
    self.dn.present?
  end

  def ldap!
    entry = Net::LDAP.new( :host => LDAP_CONFIG[:server], :port => LDAP_CONFIG[:port] ).search(
        :base => LDAP_CONFIG[:base],
        :filter => Net::LDAP::Filter.eq("mail", self.email),
        :attributes => [:mail,:gecos,:dn]
    ).first
    if entry.present?
      self.dn = entry.dn
      self.name = entry.gecos.first
      self.save!
    end
  end

protected

  def valid_credentials? password
    if self.dn.present?
      Net::LDAP.new( :host => LDAP_CONFIG[:server], :port => LDAP_CONFIG[:port]).bind(:method => :simple, :username => self.dn, :password => password)
    else
      self.valid_password? password
    end
  end

  def self.find_user_or_create_ldap_user(email)
    user = User.where(:email => email).first
    unless user.present?
      entry = Net::LDAP.new( :host => LDAP_CONFIG[:server], :port => LDAP_CONFIG[:port] ).search(
          :base => LDAP_CONFIG[:base],
          :filter => Net::LDAP::Filter.eq("mail", email),
          :attributes => [:mail,:gecos]
      ).first
      if entry.present?
        user = User.find_or_create!(:name => entry.gecos, :email => entry.mail, :dn => entry.dn)
      end
    end
    return user
  end

end
