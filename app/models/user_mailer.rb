class UserMailer < ActionMailer::Base
  
  def forgotten_password(user, request_hash)
    @subject = 'You requested reminder for your passwrd'
    @body = { "user" => user, "request_hash" => request_hash }
    @recipients = user.email
    @from = 'CATS Bugtracker Do-not-reply <sales@code-ajax.co.uk>'
  end

end
