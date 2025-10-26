# Provides tools that allow methods to be deprecated with new releases of the gem.
#
# Usage:
#   # class method deprecation example
#   class MyClass
#     extend Cyclonedx::Ruby::Deprecation
#
#     deprecated_alias :old_method, :new_method, self
#
#     def self.new_method
#       # new implementation
#     end
#   end
#
#   # instance method deprecation example
#   class MyClass
#     extend Cyclonedx::Ruby::Deprecation
#
#     deprecated_alias :old_method, :new_method
#
#     def new_method
#       # new implementation
#     end
#   end

module Cyclonedx
  module Ruby
    module Deprecation
      class << self
        attr_accessor :deprecate_in_silence
      end

      @deprecate_in_silence = false

      # Define a deprecated alias for a method
      # @param [Symbol] scope - :instance or :class (default :instance)
      # @param [Symbol] name - name of method to define
      # @param [Symbol] replacement - name of method (to alias)
      # @param [Constant] receiver - Receiver of the replacement method, use nil for instance methods (default nil)
      def deprecated_alias(scope, name, replacement, receiver = nil)
        if scope == :class
          define_singleton_method(name) do |*args, &block|
            warn("Cyclonedx: #{self}.#{name} deprecated (please use ##{replacement})") unless Cyclonedx::Ruby::Deprecation.deprecate_in_silence
            receiver ? receiver.send(replacement, *args, &block) : send(replacement, *args, &block)
          end
        else
          define_method(name) do |*args, &block|
            warn("Cyclonedx: #{self.class}##{name} deprecated (please use ##{receiver ? "#{receiver}.#{replacement}" : replacement})") unless Cyclonedx::Ruby::Deprecation.deprecate_in_silence
            receiver ? receiver.send(replacement, *args, &block) : send(replacement, *args, &block)
          end
        end
      end
    end
  end
end
