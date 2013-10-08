require 'rexml/document'

class Suite < ActiveRecord::Base
  paginates_per 20
  mount_uploader :tempest, TempestUploader
  attr_accessible :build, :description, :total_tests, :total_errors, :total_failures, :total_skip, :tempest
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
