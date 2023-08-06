class NotificationMailer < ApplicationMailer

  def send_outage_warning(email, library)
    @message = "Kramerius #{library.url} (#{library.name}) je nedostupný." 
    mail to: email, subject: "Výpadek Krameria (#{library.url})", track_opens: true
  end

  def send_outage_end_info(email, library)
    @message = "Kramerius #{library.url} (#{library.name}) je znovu dostupný." 
    mail to: email, subject: "Dostupnost Krameria (#{library.url})", track_opens: true
  end

end
