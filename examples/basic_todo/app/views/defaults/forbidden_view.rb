class Defaults::ForbiddenView < BaseView
  def template_data
    {
      template: 'defaults/forbidden',
      locals: {
        error: view_data.errors.first || "You're not authorized to do this"
      }
    }
  end

  def default_status
    :forbidden
  end
end
