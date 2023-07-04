# frozen_string_literal: true

module StickyParams
  class BaseParams
    attr_reader :controller
    attr_accessor :prefix

    def initialize(controller)
      @controller = controller
      @prefix = "#{controller.controller_name}_#{controller.action_name}_"
    end

    def []=(name, value)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= {}
      controller.session['sticky_params'][session_param_name] = controller.params[name] = value
    end

    # clears all sticky params for the current controller/action name
    def clear!
      if controller.session['sticky_params'].present?
        controller.session['sticky_params'].reject! do |key, _value|
          key.index(prefix) == 0
        end
      end
    end

    # clears all sticky parameters
    def clear_all!
      controller.session.delete('sticky_params')
    end

    # invokes the given block with another sticky_params prefix
    # (accessing other session-params withing the block)
    def with_prefix(new_prefix, &)
      old_prefix = prefix
      begin
        self.prefix = new_prefix
        yield self
      ensure
        self.prefix = old_prefix
      end
    end
  end
end
