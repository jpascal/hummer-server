module Resource::Load
  extend ActiveSupport::Concern
  included do
  private
    def self.resource(name, options = {})
      send(:before_action, options.slice(:only, :except, :if, :unless)) do |controller|
        unless instance_variable_defined?("@#{name}")
          if [Symbol, String].include? options[:object].class
            object = send(options[:object])
          else
            object = options[:object]
            case controller.params[:action].to_sym
              when :new, :create then
                object = object.new
              when :index
                return
              else
                object = object.where((options[:key] || :id).to_sym => controller.params[(options[:key] || :id).to_sym]).first!
            end
          end
          instance_variable_set "@#{name}", object
        end
      end
    end
  end
end
