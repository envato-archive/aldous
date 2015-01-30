module Aldous
  module Respondable
    module Shared
      class Flash
        attr_reader :result, :flash_container

        def initialize(result, flash_container)
          @result = result
          @flash_container = flash_container
        end

        def set_error
          flash_container[:error] = error if error
        end

        private

        def error
          result.errors.first
        end
      end
    end
  end
end
