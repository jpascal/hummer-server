class RootController < ApplicationController
  def index
    @suites = Suite.select("*, (total_errors + total_skip + total_failures) as total_passed").order("total_tests desc, total_passed desc").limit(5)
  end
end
