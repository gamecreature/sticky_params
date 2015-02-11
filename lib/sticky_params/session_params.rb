module StickyParams

  class SessionParams

    attr_reader :controller
    attr_accessor :prefix
    

    def initialize( controller )
      @controller = controller 
      @prefix = "#{controller.controller_name}_#{controller.action_name}_"
    end


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
      else
        nil
      end
    end


    def []=(name,value)
      session_param_name = "#{prefix}#{name}"
      controller.session['sticky_params'] ||= {}
      controller.session['sticky_params'][session_param_name] = controller.params[name] = value
    end


    # clears all sticky params for the given controller/action name
    def clear!
      if controller.session['sticky_params'].present?
        controller.session['sticky_params'].reject! do |key,value|
          key.index( prefix ) == 0
        end
      end
    end


    # clears all sticky parameters
    def clear_all!
      controller.session.delete('sticky_params') 
    end

  end

end