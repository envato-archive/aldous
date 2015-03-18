class SignIns::NewView < BaseView
  def template_data
    {
      template: 'sign_ins/new',
      locals: {
        user: User.new,
      }
    }
  end
end
