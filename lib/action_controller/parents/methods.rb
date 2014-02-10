module ActionController
  class Parents
    # Defines a {#parent_resources} method which can then be used instead of
    # doing `include ActionController::Parents.new(...)`.
    #
    # @example
    #
    #   class ApplicationController < ActionController::Base
    #     extend ActionController::Parents::Methods
    #   end
    #
    #   class MembersController < ApplicationController
    #     parent_resources Group, Organization
    #
    #     def index
    #       @members = parent_resource.members
    #     end
    #   end
    module Methods

      # Includes new instance of {ActionController::Parents}, defining
      # `#parent_resource` as a result.
      #
      # @param [Class<ActiveRecord::Base>] classes
      #
      # @return [undefined]
      #
      def parent_resources(*classes)
        include Parents.new(*classes)
      end
    end
  end
end
