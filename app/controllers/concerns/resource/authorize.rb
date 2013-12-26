module Resource::Authorize
  extend ActiveSupport::Concern
  included do
    delegate :can?, :can_any?, to: :current_permission
    helper_method :can?, :can_any?
    def current_permission
      @current_permission ||= Permissions.for(current_user)
    end
  private
    def self.authorize(resource = nil, options = {})
      send(:before_action, options.slice(:only, :except, :if, :unless)) do |controller|
        object = instance_variable_get("@#{resource.to_s}") if resource
        unless current_permission.can?(controller.params[:controller], controller.params[:action], object)
          Rails.logger.error "Access denied by #{@current_permission.class.name} to #{object.class.name}(#{object.try(:id).to_s}) in #{controller.params[:controller]}::#{controller.params[:action]}"
          respond_to do |format|
            format.html do
              flash[:danger] = "Access denied"
              redirect_to root_path
            end
            format.json do
              render :json => {:danger => "Access denied"}, :status => 401
            end
          end
        end
      end
    end
  end
end