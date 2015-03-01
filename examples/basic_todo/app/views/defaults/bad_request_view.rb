module Defaults
  class BadRequestView < Aldous::Respondable::Renderable
    def template
      {
        template: 'defaults/bad_request',
        locals: {
          errors: view_data.errors,
        }
      }
    end

    def default_status
      :bad_request
    end
  end
end

