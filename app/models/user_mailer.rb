class UserMailer < ActionMailer::Base
  
  def forgotten_password(user)
    @subject = 'You requested reminder for your passwrd'
    @body = {}
    # Give body access to the user information.
    @body["user"] = user
    @recipients = user.email
    @from = 'CATS Bugtracker Do-not-reply <sales@code-ajax.co.uk>'
  end

end
