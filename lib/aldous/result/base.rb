module Aldous
  module Result
    class Base
      # so we have access to the original params that were passed in
      attr_reader :_options

      # TODO this constructor is poop, need to make it better
      # maybe using inherited hook
      def initialize(options = {})
        @_options = options
        # ensure that any errors or messages end up in the appropriate array
        options.each_pair do |key, value|
          if key.to_s == 'error' || key.to_s == 'errors'
            @errors = [value].flatten.compact
          elsif key.to_s == 'message' || key.to_s == 'messages'
            @messages = [value].flatten.compact
          elsif key.to_s == 'cause'
            @cause = value
          end
        end

        self.class.class_eval do
          options.each_pair do |key, value|
            next if key.to_s == 'errors' ||
              key.to_s == 'messages' ||
              key.to_s == 'cause' # cause we already have methods for these
            define_method key do
              value
            end
          end
        end
      end

      def failure?
        false
      end

      def success?
        false
      end

      def unauthorized?
        false
      end

      def unauthenticated?
        false
      end

      def not_found?
        false
      end

      def server_error?
        false
      end

      def errors
        @errors ||= []
      end

      def messages
        @messages ||= []
      end

      # we may want to send an object which is the cause of this result
      # if addition to any errors or messages
      # this can be any object or hash or whatever is meaningful to the
      # consumer of the cause
      def cause
        @cause
      end
    end
  end
end
