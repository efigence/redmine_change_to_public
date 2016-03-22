require_dependency 'my_controller'

module RedmineChangeToPublic
  module Patches
    module MyControllerPatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          before_action :set_public_mode_for_user, only: :account

          def set_public_mode_for_user
            if request.post?
              User.current.update(public_mode: params[:user][:public_mode])
            end
          end

        end
      end

      module InstanceMethods
        # ..
      end
    end
  end
end
