require 'rexml/document'

class Suite < ActiveRecord::Base
  self.primary_key = :id
  paginates_per 20
  mount_uploader :tempest, TempestUploader
  has_many :cases, :dependent => :delete_all, :autosave => true
  belongs_to :user
  belongs_to :project
  validates :build, :user, :project_id, :presence => true
  validates :tempest, :on => :create
  validates :build, :uniqueness => {:scope => :project_id}
  # TODO: need realise membership
  #before_validation do
  #  self.project = nil unless self.user.all_projects_ids.include? self.project_id
  #end
  before_create do
    document = REXML::Document.new(self.tempest.file.read)
    self.total_errors = document.root.attributes["errors"].to_i
    self.total_failures = document.root.attributes["failures"].to_i
    self.total_tests = document.root.attributes["tests"].to_i
    self.total_skip = document.root.attributes["skip"].to_i
    document.elements.each("testsuite/testcase") do |test_case|
      tmp = self.cases.build({
        :classname => test_case.attributes["classname"],
        :name => test_case.attributes["name"],
        :time => test_case.attributes["time"].to_f
      })
      result = test_case.elements.first
      if result
        tmp.build_result(
          :type => result.name,
          :name => result.attributes["name"],
          :message => result.attributes["message"]
        )
      else
        tmp.build_result(:type => "passed")
      end
    end
  end
end
