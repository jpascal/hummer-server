class Permissions::Base
  def can(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end
  def can?(controllers, actions, resource = nil)
    @allowed_actions ||= {}

    Array(controllers).each do |controller|
      Array(actions).each do |action|

        print "can? #{controller}##{action} -> #{resource.inspect} = "

        allowed = @allowed_actions[[controller.to_s, action.to_s]]
        result = allowed && (allowed == true || resource && allowed.call(resource))
        puts "#{result || false}"
        return result if result == true
      end
    end
    false
  end
end
