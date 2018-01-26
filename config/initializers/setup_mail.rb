if Rails.env.development?
  $stderr.puts "All mails in development environment are routed to MailHog. To view the mails you need to run 'MailHog' in your console and then go to '127.0.0.1:8025'. [https://github.com/mailhog/MailHog/blob/master/docs/RELEASES.md]"
end
