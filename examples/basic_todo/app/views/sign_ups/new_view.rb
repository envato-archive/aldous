class SignUps::NewView < BaseView
  def template_data
    {
      template: 'sign_ups/new',
      locals: {
        user: User.new,
      }
    }
  end
end
