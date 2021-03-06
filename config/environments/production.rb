config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

config.action_mailer.delivery_method = :smtp

ActionMailer::Base.default_content_type = "text/html"

ActionMailer::Base.default_url_options[:host] = "www.dezineConnect.com"

ActionMailer::Base.smtp_settings = {
  :tls                => true,
  :address            => "mail.dezineconnect.com",
  :port               => "587",
  :domain             => "dezineconnect.com",
  :authentication     => :plain,
  :user_name          => "team@dezineconnect.com",
  :password           => "t1e2a3m4dezineconnect"
}

SITE_URL  = "www.dezineConnect.com"
