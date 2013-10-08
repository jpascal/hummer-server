class CasesController < ApplicationController
  before_filter :load_suite
  def show
    @case = @suite.cases.find(params[:id])
    @related_cases = Case.where("cases.id != ?", @case).where(:classname => @case.classname, :name => @case.name).includes(:result)
  end
  def paste
    @case = @suite.cases.find(params[:id])
    unless @case.paste
      @case.paste = Paste2::Client.post(@case.result.message)
      @case.save!
    end
    redirect_to @case.paste
  end
private
  def load_suite
    @suite = Suite.find(params[:report_id])
  end
end
