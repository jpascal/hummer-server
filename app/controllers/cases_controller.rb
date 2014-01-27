class CasesController < ApplicationController
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :suite, :through => :project, :source => :suites, :key => :suite_id, :parent => true
  resource :case, :through => :suite, :source => :cases
  authorize :case
  def show
    @related_cases = Case.where.not(:suite_id =>@case.suite).where(:classname => @case.classname, :name => @case.name)
    @related_bugs = Bug.where(:classname => @case.classname, :name => @case.name).where.not(:case_id => @case)
  end
  def paste
    unless @case.paste
      @case.paste = Paste2::Client.post(@case.message)
      @case.save!
    end
    redirect_to @case.paste
  end
end
