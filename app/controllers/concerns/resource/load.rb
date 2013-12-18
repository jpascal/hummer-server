module Resource::Load
  extend ActiveSupport::Concern
  included do
  private
    def self.resource(name, options = {})
      send(:before_action, options.slice(:only, :except, :if, :unless)) do |controller|
        unless instance_variable_defined?("@#{name}")

          if options[:through] and options[:source]
            object = instance_variable_get("@#{options[:through].to_s}")
            object = object.send(options[:source])
          elsif [Symbol, String].include? options[:object].class
            object = send(options[:object])
          else
            object = options[:object]
          end

          if options[:parent]
            object = object.where(:id => controller.params[(options[:key] || :id).to_sym]).first!
          else
            case controller.params[:action].to_sym
              when :new, :create then
                object = object.new
              when :index
                return
              else
                object = object.where(:id => controller.params[(options[:key] || :id).to_sym]).first!
            end
          end
          instance_variable_set "@#{name}", object
        end
      end
    end
  end
end
