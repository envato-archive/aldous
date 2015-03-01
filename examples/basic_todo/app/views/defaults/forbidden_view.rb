module Defaults
  class ForbiddenView < Aldous::Respondable::Renderable
    def template
      {
        template: 'defaults/forbidden',
        locals: {
        }
      }
    end

    def default_status
      :forbidden
    end
  end
end
