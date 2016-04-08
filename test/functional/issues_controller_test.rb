require File.expand_path('../../test_helper', __FILE__)

class IssuesControllerTest < Redmine::IntegrationTest
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')
  fixtures :all

  def setup
    Journal.destroy_all
    Journal.create(journalized_id: 1,
                   journalized_type: "Issue",
                   user_id: 2,
                   notes: "Journal notes 1",
                   created_on: Time.now - 3.days,
                   private_notes: false)
    Journal.create(journalized_id: 1,
                   journalized_type: "Issue",
                   user_id: 2,
                   notes: "Journal notes 2",
                   created_on: Time.now - 2.days,
                   private_notes: true)
  end

  def test_issue_show_action_shouldnt_assign_private_journals
    log_user('admin', 'admin')
    User.current.update(public_mode: true)
    get issue_path(Issue.find(1))
    assert_response 200
    assert assigns(:journals).size, 1
  end

end
