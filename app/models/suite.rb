require 'nokogiri'

class Suite < ActiveRecord::Base
  self.primary_key = :id
  paginates_per 20
  mount_uploader :tempest, TempestUploader
  acts_as_taggable_on :features
  has_many :cases, :dependent => :delete_all, :autosave => true
  belongs_to :user
  belongs_to :project
  validates :build, :user, :project_id, :presence => true
  validates :tempest, :presence => true, :on => :create
  validates :build, :uniqueness => {:scope => :project_id}
  # TODO: need realise membership
  #before_validation do
  #  self.project = nil unless self.user.all_projects_ids.include? self.project_id
  #end
  def reload
    Result.where(:id => self.case_ids).delete_all
    self.cases.delete_all
    parse_tempest
    self.save!
  end
  def parse_tempest
    document = Nokogiri::XML(self.tempest.file.read)
    self.total_errors = document.root.attribute("errors").value.to_i
    self.total_failures = document.root.attribute("failures").value.to_i
    self.total_tests = document.root.attribute("tests").value.to_i
    self.total_skip = document.root.attribute("skip").value.to_i
    self.total_passed = self.total_tests - (self.total_errors + self.total_skip + self.total_failures)
    document.xpath("testsuite/testcase").each do |test_case|
      tmp = self.cases.build({
                                 :classname => test_case.attribute("classname").value,
                                 :name => test_case.attribute("name").value,
                                 :time => test_case.attribute("time").value.to_f
                             })
      result = test_case.elements.first
      if result.present?
        tmp.build_result(
            :type => result.name,
            :name => result.attribute("type").value,
            :message => result.attribute("message").value
        )
      else
        tmp.build_result(:type => "passed")
      end
    end
  end
  before_create do
    parse_tempest
  end

  def bugs
    cases.where("tracker IS NOT NULL").includes(:result)
  end

  def percents
    results = {
        :errors => ((total_errors.to_f / total_tests.to_f) * 100).to_i,
        :failures => ((total_failures.to_f / total_tests.to_f) * 100).to_i,
        :skip => ((total_skip.to_f / total_tests.to_f) * 100).to_i,
    }
    results[:tracked] = ((bugs.count.to_f / (total_errors + total_failures).to_f) * 100).to_i
    results[:passed] = (100 - results[:errors] - results[:failures] - results[:skip])
    results
  end

  def user_name
    user.name || ""
  end
  def as_json
    super(:methods => [:feature_list,:user_name],:except => :user_id)
  end

end
