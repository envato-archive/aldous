require 'aldous/simple_dto'
require 'aldous/service/result/base/predicate_methods_for_inheritance'

module Aldous
  class Service
    module Result
      class Base < ::Aldous::SimpleDto
        extend PredicateMethodsForInheritance
      end
    end
  end
end

