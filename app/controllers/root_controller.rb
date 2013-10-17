class RootController < ApplicationController
  def index
    redirect_to suites_path
  end
end
