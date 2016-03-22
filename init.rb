
Redmine::Plugin.register :redmine_change_to_public do
  name 'Change To Public'
  author 'Jan Lachowicz'
  description 'A plugin for hiding private notes'
  version '0.0.1'

  # menu :account_menu,
  #      :change_to_public, {controller: 'users', action: 'toggle_public_mode'}, first: true,
  #      :caption => proc { if User.current.public_mode; 'Exit public mode'; else; 'Enter public mode'; end },
  #      :if => proc { User.current.logged? }

  ActionDispatch::Callbacks.to_prepare do
    require 'redmine_change_to_public/hooks'
    ApplicationController.send(:include, RedmineChangeToPublic::Patches::ApplicationControllerPatch)
    MyController.send(:include, RedmineChangeToPublic::Patches::MyControllerPatch)
    IssuesController.send(:include, RedmineChangeToPublic::Patches::IssuesControllerPatch)
    AttachmentsHelper.send(:include, RedmineChangeToPublic::Patches::AttachmentsHelperPatch)
  end
end
