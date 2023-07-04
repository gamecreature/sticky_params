module StickyParams
  class SessionParams < BaseParams
    def [](name)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= {}
      if controller.params[name]
        if controller.params[name].present?
          controller.session['sticky_params'][session_param_name] = controller.params[name]
        else
          controller.session['sticky_params'].delete session_param_name
          nil
        end
      elsif controller.session['sticky_params'][session_param_name]
        controller.session['sticky_params'][session_param_name]
      end
    end
  end
end