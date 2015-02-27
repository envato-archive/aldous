module Users
  class IndexRedirect < Aldous::Respondable::Redirectable
    def location
      view_context.root_path
    end
  end
end
