# Load mail configuration if not in test environment
if RAILS_ENV != 'test'
  email_settings = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = email_settings[RAILS_ENV] unless email_settings[RAILS_ENV].nil?
end

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8" 

# # We'll use this instead
# # No we won't :P
# ActionMailer::Base.delivery_method = :sendmail
# ActionMailer::Base.sendmail_settings = {  
#     :location => '/usr/sbin/sendmail',  
#     :arguments => '-i -t' 
#   } 

