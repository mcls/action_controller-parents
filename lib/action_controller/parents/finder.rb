module ActionController
  class Parents
    NoFindMethodError = Class.new(StandardError)

    # Used to find the parent resource
    #
    # @api private
    #
    class Finder
      attr_reader :parent_resource_classes, :primary_keys

      FIND_METHOD = :find_by_id!

      # @param [Class<ActiveRecord::Base>] parent_resource_classes
      def initialize(*parent_resource_classes)
        @parent_resource_classes = parent_resource_classes.flatten
        @parent_resource_classes.each do |c|
          unless c.respond_to?(FIND_METHOD)
            fail NoFindMethodError,
              "Parent resource #{c.name} doesn't respond to #{FIND_METHOD.inspect}"
          end
        end
        setup_primary_keys
      end

      def parent_resource(hsh)
        key = matched_key(hsh)
        return nil unless key
        class_by_key(key).public_send(FIND_METHOD, hsh[key])
      end

      private

      def matched_key(hsh)
        hsh.keys.detect { |key| valid_primary_key?(key) }
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
