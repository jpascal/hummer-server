class AddTotalPassed < ActiveRecord::Migration
  def up
    add_column :suites, :total_passed, :integer
    Suite.all.each do |suite|
      suite.total_passed = suite.total_tests - (suite.total_errors + suite.total_skip + suite.total_failures)
      suite.save(:validate => false)
    end
  end
  def down
    remove_column :suites, :total_passed
  end
end
