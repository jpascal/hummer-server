class DescriptionsController < ApplicationController
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :suite, :through => :project, :source => :suites, :key => :suite_id, :parent => true
  resource :case, :through => :suite, :source => :cases, :key => :case_id

  def show
  end
  def update
    @case.description = params[:description]
    @case.save
  end
  def destroy
    @case.description = nil
    @case.save
  end
end
