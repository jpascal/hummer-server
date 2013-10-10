require 'rexml/document'

class Suite < ActiveRecord::Base
  paginates_per 20
  mount_uploader :tempest, TempestUploader
  default_scope :select => "*, (total_errors + total_skip + total_failures) as total_passed"
  has_many :comments, :as => :resource, :dependent => :delete_all, :order =>  "created_at desc"
  scope :best_builds, :select => "*, (total_errors + total_skip + total_failures) as total_passed", :order => "total_tests desc, total_passed desc", :limit => 10
  has_many :cases, :dependent => :delete_all, :autosave => true
  validates :build, :presence => true, :uniqueness => true
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
