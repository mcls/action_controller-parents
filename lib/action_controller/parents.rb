require 'active_support/core_ext/string/conversions'
require 'action_controller/parents/finder'
require 'action_controller/parents/methods'
require 'action_controller/parents/version'

module ActionController
  # To be included in a controller.
  #
  # Creates a `parent_resource` method, which will call `find_by_id!` using an id
  # found in the params hash.
  #
  # @example Organization and Group as parents
  #
  #   class MembersController < ActionController::Base
  #     include ActionController::Parents.new(Organization, Group)
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
  end # Parents
end
