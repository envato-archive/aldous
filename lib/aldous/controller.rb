require 'aldous/controller/action_execution_service'

module Aldous
  module Controller
    include Aldous

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def controller_actions(*actions)
        actions.each do |action_name|
          define_method action_name do
            ::Aldous::Controller::ActionExecutionService.perform(self, self.class.const_get(action_name.to_s.classify))
          end
        end
      end
    end
  end
end
