module Users
  class IndexView < Aldous::Respondable::Renderable
    def template
      {
        template: 'users/index',
        locals: {
          header_template: header_template,
          user_templates: user_templates,
        }
      }
    end

    private

    def users
      result.users
    end

    def header_template
      Modules::HeaderView.new(result, view_context).template
    end

    def user_templates
      users.map do |user|
        user_template(user)
      end
    end

    def user_template(user)
      Users::IndexView::UserView.new(build_result(user: user), view_context).template
    end
  end
end
