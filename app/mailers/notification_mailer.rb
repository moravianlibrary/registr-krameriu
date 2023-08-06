class NotificationMailer < ApplicationMailer

  def send_outage_warning(email, library)
    @message = "Kramerius #{library.url} (#{library.name}) je nedostupný." 
    mail to: email, subject: "Výpadek Krameria (#{library.url})", track_opens: true
  end

end
