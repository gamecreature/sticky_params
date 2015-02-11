require "sticky_params/version"
require "sticky_params/railtie" if defined?(Rails)
require "sticky_params/session_params"


# 
# Sticky Parameters is a nice hack that allows the 'remembering' a given param
# between page requests. When a param is supplied it is stored in a session.
#
# When the param isn't supplied it tries to recieve it from the session.
#
# When an 'empty-string' is supplied as param, the sticky_param is removed
#
# Use it the following way. Simply use sticky_params in stead of params
# <pre>  
#   selection = sticky_params[:name]
# </pre>
#

module StickyParams


  # A sicky parameter is a parameter that 'keeps' it state between pages,
  # by storing the data in a session
  def sticky_params
    @sticky_params ||= ::StickyParams::SessionParams.new(self)
  end

end