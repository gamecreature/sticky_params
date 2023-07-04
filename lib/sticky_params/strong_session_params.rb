module StickyParams
  class StrongSessionParams < BaseParams
    def fetch_from_params(name, session_param_name)
      if controller.params[name].present?
        if controller.params[name].is_a?(ActionController::Parameters)
          controller.session['sticky_params'][session_param_name] = controller.params[name].to_unsafe_hash
        else
          controller.session['sticky_params'][session_param_name] = controller.params[name]
        end
        controller.params[name]
      else
        controller.session['sticky_params'].delete session_param_name
        nil
      end
    end

    def fetch_from_session(session_param_name)
      result = controller.session['sticky_params'][session_param_name]
      # covert hash to action parameters for simulating a normal param
      result.is_a?(Hash) ? ActionController::Parameters.new(result) : result
    end

    def [](name)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= {}
      if controller.params[name]
        fetch_from_params(name, session_param_name)
      elsif controller.session['sticky_params'][session_param_name]
        fetch_from_session(session_param_name)
      end
    end
  end
end
