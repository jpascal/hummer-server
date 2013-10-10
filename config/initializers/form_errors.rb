module Hummer
  module FormBuilder
    def block_for(method, options = {}, &block)
      if @object.errors.has_key? method.to_sym
        options[:class] = options[:class].present? ? options[:class] + " error" : "error"
      end
      @template.content_tag :div, options do
        block.call
      end
    end
    def errors_for *fields

      errors = @object.errors.messages.select{|field,value| fields.include? field and not value.empty? }
      return unless errors.any?
      errors = Hash[errors.map {|field, value| ["#{object_name}_#{field}", value.first] }]

      @template.render "application/form_errors", :errors => errors
    end
    def error_for(method, tag = :span, options = {})
      @template.content_tag tag, options do
        @object.errors[method.to_sym].first
      end if @object.errors.has_key? method.to_sym
    end
    def error_for_base(tag = :div, options = {})
      options[:class] = options[:class].present? ? options[:class] + " base-error" : "base-error"
      @template.content_tag tag, options do
        @object.errors[:base].first
      end if @object.errors[:base].any?
    end
  end
end

ActionView::Base.field_error_proc = Proc.new { |html_tag, object| html_tag }
ActionView::Helpers::FormBuilder.send(:include,  Hummer::FormBuilder)