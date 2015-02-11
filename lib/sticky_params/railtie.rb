module StickyParams

  class Railtie < Rails::Railtie

    initializer "sticky_params.add_controller_extenion" do
      ActionController::Base.send :include, StickyParams
    end

  end

end