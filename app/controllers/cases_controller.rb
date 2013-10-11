class CasesController < ApplicationController
  load_and_authorize_resource :suite
  load_and_authorize_resource :case, :through => :suite
  def show
    @related_cases = Case.where("suite_id != ?", @case.suite).where(:classname => @case.classname, :name => @case.name).includes(:result)
  end
  def paste
    unless @case.paste
      @case.paste = Paste2::Client.post(@case.result.message)
      @case.save!
    end
    redirect_to @case.paste
  end
end
