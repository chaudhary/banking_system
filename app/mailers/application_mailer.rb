class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  self.smtp_settings = {
    address: '127.0.0.1',
    port: 1025,
  }

  private

  def send_mail(options = {})
    @from ||=  "Test Bank <support@testbank.com>"
    options_hash  = {}
    options_hash.store(:to, @to)
    options_hash.store(:bcc, @bcc) if @bcc.present?
    options_hash.store(:from, @from)
    options_hash.store(:subject, @subject)
    options_hash.store(:reply_to, @reply_to) if @reply_to.present?

    layout_hash = {}
    options[:template_name] ||= self.instance_variable_get('@_action_name')

    layout_hash.store(:template, "/#{self.class.name.underscore}/#{options[:template_name]}")

    mail(options_hash) do |format|
      format.html {render layout_hash}
    end
  end
end
