require "action_controller/parents/version"

module ActionController
  # To be included in a controller.
  #
  # Creates a `parent_resource` method, which will call `find_by_id!` using an id
  # found in the params hash.
  #
  # @example Organization and Group as parents
  #
  #   class MembersController < ActionController::Base
  #     include Parents.new(Organization, Group)
  #
  #     def index
  #       @members = parent_resource.members
  #     end
  #   end
  #
  # @!method parent_resource()
  #   Fetches the parent resource.
  #
  #   @return [ActiveRecord::Base, nil] The result or `nil` if no matching key
  #     has been found.
  #
  #   @raise [ActiveRecord::RecordNotFound] When a parent resource key is
  #     present, but no parent resource is found for it.
  #
  class Parents < Module
    private

    def initialize(*resource_classes)
      @finder = Finder.new(resource_classes)
    end

    def included(base)
      finder = @finder
      base.class_eval do
        define_method :parent_resource do
          finder.parent_resource(params)
        end
      end
    end

    # Used to find the parent resource
    #
    # @api private
    #
    class Finder
      attr_reader :parent_resource_classes, :primary_keys

      # @param [Class<ActiveRecord::Base>] parent_resource_classes
      def initialize(*parent_resource_classes)
        @parent_resource_classes = parent_resource_classes.flatten
        setup_primary_keys
      end

      def parent_resource(hsh)
        key = matched_key(hsh)
        return nil unless key
        to_resource_class(key).find_by_id!(hsh[key])
      end

      def to_resource_class(key)
        key.to_s.sub(/_id$/, '').classify.constantize
      end

      def matched_key(hsh)
        hsh.keys.detect { |key| valid_primary_key?(key) }
      end

      def valid_primary_key?(key)
        primary_keys.include?(key.to_s)
      end

      def setup_primary_keys
        @primary_keys = parent_resource_classes.map { |klass|
          klass.to_s.underscore.concat('_id')
        }
      end
    end
  end
end
