require_dependency 'issues_controller'

module RedmineChangeToPublic
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable
          base.send(:include, InstanceMethods)
          # prepend_before_filter :find_issue_and_project, :only => [:create_notification]
          # prepend_after_filter :public_journals, :only => [:show],
          #  :if => proc { User.current.logged? }
          alias_method_chain :show, :public_mode
        end
      end
      module InstanceMethods
        def show_with_public_mode
          if User.current.public_mode
            public_journals
          else
            show_without_public_mode
          end
        end

        def public_journals
          @journals = @issue.journals.where(private_notes: false).includes(:user, :details).
                          references(:user, :details).
                          reorder("#{Journal.table_name}.id ASC").to_a
          @journals.each_with_index {|j,i| j.indice = i+1}
          @journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
          Journal.preload_journals_details_custom_fields(@journals)
          @journals.select! {|journal| journal.notes? || journal.visible_details.any?}
          @journals.reverse! if User.current.wants_comments_in_reverse_order?

          @changesets = @issue.changesets.visible.to_a
          @changesets.reverse! if User.current.wants_comments_in_reverse_order?

          @relations = @issue.relations.select {|r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
          @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
          @priorities = IssuePriority.active
          @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
          @relation = IssueRelation.new

          respond_to do |format|
            format.html {
              retrieve_previous_and_next_issue_ids
              render :template => 'issues/show'
            }
            format.api
            format.atom { render :template => 'journals/index', :layout => false, :content_type => 'application/atom+xml' }
            format.pdf  {
              send_file_headers! :type => 'application/pdf', :filename => "#{@project.identifier}-#{@issue.id}.pdf"
            }
          end
        end
      end
    end
  end
end
