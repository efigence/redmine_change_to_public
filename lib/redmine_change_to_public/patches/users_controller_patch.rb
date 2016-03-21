require_dependency 'users_controller'

module RedmineChangeToPublic
  module Patches
    module UsersControllerPatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          def toggle_public_mode
            user = User.current
            user.update_attribute(:public_mode, !user.public_mode)
            redirect_to :back
          end

        end
      end

      module InstanceMethods
        # ..
      end
    end
  end
end
