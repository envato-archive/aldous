module SignIns
  class NewView < Aldous::Respondable::Renderable
    def template
      {
        template: 'sign_ins/new',
        locals: {
          header_template: header_template,
          user: User.new,
        }
      }
    end

    private

    def header_template
      build_view(Modules::HeaderView).template
    end
  end
end
