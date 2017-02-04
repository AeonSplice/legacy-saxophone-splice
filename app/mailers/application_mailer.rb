class ApplicationMailer < ActionMailer::Base
  default from: 'Aeon Splice <noreply@aeonsplice.com>',
          reply_to: 'Aeon Splice Admin <admin@aeonsplice.com>'
  layout 'mailer'
end
