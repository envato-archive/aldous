module Users
  class IndexView < Aldous::Respondable::Renderable
    class UserView < Aldous::Respondable::Renderable
      def template
        {
          partial: 'users/index_view/user',
          locals: {
            email: user_email,
          }
        }
      end

      private

      def user
        result.user
      end

      def user_email
        if user
          user.email
        end
      end
    end
  end
end
