class ComparesController < ApplicationController
  load_and_authorize_resource :suite, :id_param => :suite_id
  load_and_authorize_resource :compare, :class => "Suite"
  def index
    @compares = @compares.where("id != ?",@suite).page(params[:page])
  end
  def show
    if params[:id] == @suite.id.to_s
      flash[:warning] = "You can't compare equal suites"
      redirect_to suites_path
    end

    params[:type] ||= "error"

    @cases_suite = @suite.cases.includes(:result).all.to_a
    @cases_compare = @compare.cases.includes(:result).all.to_a

    @compares = []

    @cases_suite.each do |case_suite|
      found_case, index = find_in_cases @cases_compare, case_suite.name

      if found_case
        if found_case.result.type != case_suite.result.type
          @compares << [case_suite, found_case]
        end
        @cases_compare.delete_at index
      else
        @compares << [case_suite, nil]
      end
    end
    @cases_compare.each do |c|
      @compares << [nil, c]
    end
    @compares = Kaminari.paginate_array(@compares).page(params[:page]).per(20)
  end
private
  def find_in_cases cases, name
    cases.each_with_index do |c,i|
      return [c,i] if c.name == name
    end
    return [nil, nil]
  end
end
