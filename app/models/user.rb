require 'securerandom'

class User < ActiveRecord::Base
  include ActiveModel::AttributeMethods
  self.primary_key = :id

  has_many :suites

  has_many :members, :dependent => :delete_all

  attr_accessor :ldap
  def ldap
    @ldap ||= self.dn.present?
  end


  after_validation do
    unless errors.any?
      puts self.ldap
      puts self.dn
    end
    #if self.ldap
    #  puts "ldap - #{self.ldap}"
    #  if user = User.find_ldap(:mail, self.email)
    #    @ldap = true
    #    self.dn = user.dn
    #  else
    #    puts "not found"
    #  end
    #else
    #  @ldap = false
    #  self.dn = nil
    #end
  end

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
  end

  merge_validates_length_of_password_field_options :if => Proc.new {|user| not user.ldap}, :within => 8..20
  validates :name, :length => { :minimum => 8, :maximum => 20 }, :presence => true

  acts_as_authentic do |config|
    config.login_field = :email
  end

  before_validation do
    if self.ldap
      if object = User.find_ldap(:mail, self.email)
        puts object.inspect
        self.dn = object.dn
        self.name = object.cn.first
      end
    else
      self.dn = nil
    end
  end

  def self.find_ldap(key, value, attributes = [:mail, :cn, :dn, :userPassword])
    ldap = Net::LDAP.new(:host => LDAP_CONFIG[:server], :port => LDAP_CONFIG[:port], :base => LDAP_CONFIG[:base])
    ldap.search(
        :filter => Net::LDAP::Filter.eq(key, value),
        :attributes => attributes,
        :return_result => true
    ).first
  end

protected


  def valid_credentials? password

    if self.dn.present?
      tmp = Net::LDAP.new(:host => LDAP_CONFIG[:server], :port => LDAP_CONFIG[:port])
      tmp.auth self.dn, password
      if tmp.bind
        true
      else
        puts "LDAP response: #{tmp.get_operation_result.message}"
        false
      end
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
          :attributes => [:mail,:cn,:dn]
      )
      if entry.present? and entry.first.present?
        entry = entry.first
        user = User.where(:name => entry.cn.first, :email => email, :dn => entry.dn).first_or_create
      end
    end
    return user
  end

end
