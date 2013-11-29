class ComparesController < ApplicationController
  load_and_authorize_resource :suite, :id_param => :suite_id
  load_and_authorize_resource :compare, :class => "Suite"
  def index
    @compares = @compares.where.not(:id => @suite).order("created_at desc").page(params[:page])
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
private
  def find_in_cases cases, name
    cases.each_with_index do |c,i|
      return [c,i] if c.name == name
    end
    return [nil, nil]
  end
end
