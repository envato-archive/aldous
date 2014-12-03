module Aldous
  module ResponseAction
    class Flash
      class << self
        def for_render(controller, result)
          self.new(result, controller.flash.now)
        end

        def for_redirect(controller, result)
          self.new(result, controller.flash)
        end
      end

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
