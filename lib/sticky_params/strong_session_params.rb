module StickyParams
  class StrongSessionParams
    attr_reader :controller
    attr_accessor :prefix

    def initialize(controller)
      @controller = controller
      @prefix = "#{controller.controller_name}_#{controller.action_name}_"
    end

    def fetch_from_params(name, session_param_name)
      if controller.params[name].present?
        controller.session['sticky_params'][session_param_name] = controller.params[name]
      else
        controller.session['sticky_params'].delete session_param_name
        nil
      end
    end

    def fetch_from_session(session_param_name)
      result = controller.session['sticky_params'][session_param_name]

      # covert hash to action parameters for simulating a normal param
      if result.is_a?(Hash)
        result = ActionController::Parameters.new(result)
        controller.session['sticky_params'][session_param_name] = result
      end

      result
    end

    def [](name)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= ActionController::Parameters.new
      if controller.params[name]
        fetch_from_params(name, session_param_name)
      elsif controller.session['sticky_params'][session_param_name]
        fetch_from_session(session_param_name)
      end
    end

    def []=(name, value)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= ActionController::Parameters.new
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
  end
end