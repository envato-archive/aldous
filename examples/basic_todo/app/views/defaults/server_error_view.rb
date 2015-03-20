class Defaults::ServerErrorView < BaseView
  def template_data
    {
      template: 'defaults/server_error',
      locals: {
        errors: view_data.errors,
      }
    }
  end

  def default_status
    :internal_server_error
  end
end
