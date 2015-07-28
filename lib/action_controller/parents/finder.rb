module ActionController
  class Parents
    NoFindMethodError = Class.new(StandardError)

    # Used to find the parent resource
    #
    # @api private
    #
    class Finder
      attr_reader :parent_resource_classes, :primary_keys

      FIND_METHOD = :find

      # @param [Class<ActiveRecord::Base>] parent_resource_classes
      def initialize(*parent_resource_classes)
        @parent_resource_classes = parent_resource_classes.flatten
        assert_responds_to_find_method(@parent_resource_classes)
        setup_primary_keys
      end

      # Finds the parent resources from the ActionController params hash
      # @params [Hash] params
      # @return [ActiveRecord::Base, nil]
      def parent_resource(params)
        key = find_primary_key(params)
        return nil unless key
        class_by_key(key).public_send(FIND_METHOD, params[key])
      end

      private

      def assert_responds_to_find_method(classes)
        res = classes.find { |c| !c.respond_to?(FIND_METHOD) }
        unless res.nil?
          fail NoFindMethodError,
            "Parent resource #{res.name} doesn't respond to #{FIND_METHOD.inspect}"
        end
      end

      # Looks for the primary key of any of the parent resources in the params
      # hash
      # @params [Hash] params
      # @return [String, nil]
      def find_primary_key(params)
        params.keys.detect { |key| valid_primary_key?(key) }
      end

      def valid_primary_key?(key)
        !class_by_key(key).nil?
      end

      def class_by_key(key)
        primary_keys[key.to_s]
      end

      def setup_primary_keys
        @primary_keys = parent_resource_classes.each_with_object({}) do |klass, hsh|
          hsh[klass.to_s.foreign_key] = klass
        end
      end
    end
  end
end
