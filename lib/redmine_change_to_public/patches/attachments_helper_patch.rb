require_dependency 'attachments_helper'

module RedmineChangeToPublic
  module Patches
    module AttachmentsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          alias_method_chain :link_to_attachments, :public_mode
        end
      end
      module InstanceMethods
        def link_to_attachments_with_public_mode(container, options = {})
          if User.current.public_mode
            options.assert_valid_keys(:author, :thumbnails, :only_visible)

            attachments = container.attachments.where(is_private: false).preload(:author).to_a
            attachments.select!(&:visible?) if options[:only_visible]

            if attachments.any?
              options = {
                :editable => container.attachments_editable?,
                :deletable => container.attachments_deletable?,
                :author => true
              }.merge(options)
              render :partial => 'attachments/links',
                :locals => {
                  :container => container,
                  :attachments => attachments,
                  :options => options,
                  :thumbnails => (options[:thumbnails] && Setting.thumbnails_enabled?)
                }
            end
          else
            link_to_attachments_without_public_mode(container, options = {})
          end
        end

      end
    end
  end
end
