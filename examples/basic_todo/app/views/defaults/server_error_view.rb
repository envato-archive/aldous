module Defaults
  class ServerErrorView < Aldous::Respondable::Renderable
    def template
      {
        partial: 'defaults/server_error',
        locals: {
          errors: result.errors,
        }
      }
    end
  end
end
