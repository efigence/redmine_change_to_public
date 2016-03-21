require_dependency 'application_controller'

module RedmineChangeToPublic
  module Patches
    module ApplicationControllerPatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          before_action :set_public_mode_variable

          def set_public_mode_variable
            @public_mode = User.current.public_mode if User.current.logged?
          end

        end
      end

      module InstanceMethods
        # ..
      end
    end
  end
end
