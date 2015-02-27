Aldous.configuration do |aldous|
  aldous.logger = Rails.logger

  aldous.controller_methods_exposed_to_controller_service += [:current_user]

  aldous.default_html_response_types = {
    Aldous::Result::ServerError => Defaults::ServerErrorView,
  }
end
