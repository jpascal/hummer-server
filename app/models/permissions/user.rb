class Permissions::User < Permissions::Base
  def initialize(current_user)

    current_user ||= User.new

    # for all users
    can "suites", ["index","paste","show","search"]
    can "projects", "index"
    can "projects", "show" do |project|
      not project.private
    end
    can "bugs", ["index", "show"]
    can "compares", ["index","show"]
    can "cases", ["index","paste","show"]
    can "cases", ["index","paste","show"]
    can "tracker", "show" do |test|
      test.bug.present?
    end

    if current_user.new_record?
      # anonymous
      can "sessions", ["create", "new"]
      can "users", ["create", "new", "recovery"]
    else

      can "trackers",["edit","show","update"] do |test|
        Project.for(current_user).ids.include? test.suite.project_id
      end

      # existent user
      can "sessions", "destroy"

      can "descriptions", ["update","show","destroy"] do |test|
        test.suite.user == current_user or test.suite.project.members.where(:user_id => current_user, :owner => true).any?
      end

      can "projects", "show" do |project|
        not project.private or project.members.where(:user_id => current_user).any?
      end

      can "projects", ["edit","update"] do |project|
        project.members.where(:user_id => current_user, :owner => true).any?
      end
      can "suites", ["create","new"] do |project|
        project.members.where(:user_id => current_user).any?
      end
      can "suites", ["edit","update"] do |suite|
        suite.user == current_user or suite.project.members.where(:user_id => current_user, :owner => true).any?
      end
      can "suites", "reload" do |suite|
        suite.tempest.present? and ( suite.user == current_user or suite.project.members.where(:user_id => current_user, :owner => true).any?)
      end
      can "suites", "destroy" do |suite|
        suite.user == current_user or suite.project.members.where(:user_id => current_user, :owner => true).any?
      end

      can "users",["show"]
      can "tracker", ["show","update"]
      can "users", ["edit","update","token"] do |user|
        current_user == user
      end
      can "members", "index"
      can "members", ["new", "create"] do |project|
        project.members.where(:user_id => current_user, :owner => true).any?
      end
      can "members", ["destroy","edit", "update"] do |member|
        member.project.members.where(:user => current_user, :owner => true).any? and member.user != current_user
      end
      # API permissions
      can "api/projects", [ "index", "show" ]
      can "api/suites", [ "index", "create", "show" ]
      if current_user.admin?

        can "members", ["new", "create"]
        can "members", ["destroy","edit", "update"] do |member|
          member.user != current_user
        end

        can "users", ["index", "edit","update", "serarch"]
        can "users", "destroy" do |user|
          user != current_user
        end
        can "suites", ["edit","update", "destroy"]
        can "suites", "reload" do |suite|
          suite.tempest.present?
        end
        can "projects", ["create","new","edit","update","destroy"]
      end
    end
  end
end