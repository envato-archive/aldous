module Aldous
  class SimpleDto
    attr_reader :_data

    def initialize(data = {})
      @_data = data

      handle_errors_and_messages
      define_accessors
    end

    def errors
      @errors ||= []
    end

    def messages
      @messages ||= []
    end

    private

    def handle_errors_and_messages
      # ensure that any errors or messages end up in the appropriate array
      _data.each_pair do |key, value|
        if key.to_s == 'errors'
          @errors = [value].flatten.compact
        elsif key.to_s == 'messages'
          @messages = [value].flatten.compact
        end
      end
    end

    def define_accessors
      self.class.class_exec(_data) do |_data|
        _data.each_key do |key|
          next if key.to_s == 'errors' || key.to_s == 'messages'
          # do nothing if method is already defined
          next if instance_methods(false).include?(key.to_sym)

          define_method key do
            @_data[key]
          end
        end
      end
    end
  end
end
