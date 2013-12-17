class ComparesController < ApplicationController
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :suite, :through => :project, :source => :suites, :key => :suite_id, :parent => true
  resource :compare, :through => :project, :source => :suites
  authorize :suite
  authorize :compare
  def index
    @compares = @project.suites.where.not(:id => @suite).order("created_at desc").page(params[:page])
  end
  def show
    if params[:id] == @suite.id.to_s
      flash[:warning] = "You can't compare equal suites"
      redirect_to suites_path
    end
    @diff = Suite.compare(@suite,@compare)
    @differen = @diff.count
    @diff = Kaminari.paginate_array(@diff.to_a).page(params[:page])
  end
end
