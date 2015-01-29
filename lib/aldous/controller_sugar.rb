require 'aldous'

module Aldous
  module ControllerSugar
    private

    def perform_with *args
      @result = _service_class.new(*args).perform_with
    end

    def dispatch_with(mapping)
      Aldous::ResultDispatcher.execute(self, @result, _expand_mapping(mapping))
    end

    def dispatch_with_params(mapping)
      perform_with(params: params)
      dispatch_with mapping
    end

    # internal

    def _expand_mapping(mapping)
      view_namespace = self.class.to_s.gsub(/Controller$/,'').constantize
      array = mapping.map do |key, value|
        [
          _coalesce_constant(Aldous::Result, key),
          _coalesce_constant(view_namespace, value)
        ]
      end
      Hash[array]
    end

    def _coalesce_constant(base, const_or_symbol)
      if const_or_symbol.class == Class
        const_or_symbol
      else
        base.const_get(const_or_symbol.to_s.classify)
      end
    end

    def _service_class
      service_name  = "#{params[:action].classify}Service"
      self.class.const_get(service_name)
    end

  end
end