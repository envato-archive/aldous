class Defaults::BadRequestView < BaseView
  def template_data
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

