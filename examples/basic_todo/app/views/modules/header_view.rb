module Modules
  class HeaderView < Aldous::Respondable::Renderable
    def template
      {
        partial: 'modules/header',
        locals: {
          current_user: current_user
        }
      }
    end

    private

    def current_user
      result.current_user
    end
  end
end

