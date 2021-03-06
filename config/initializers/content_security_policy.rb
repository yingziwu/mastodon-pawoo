# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

base_host     = Rails.configuration.x.web_domain
assets_host   = Rails.configuration.action_controller.asset_host
assets_host ||= "http#{Rails.configuration.x.use_https ? 's' : ''}://#{base_host}"

Rails.application.config.content_security_policy_nonce_generator = -> (_request) { SecureRandom.base64(32) }

pawoo_script_src = ['https://www.google-analytics.com', 'https://ssl.google-analytics.com']
pawoo_img_src = ['https://www.google-analytics.com']
pawoo_connect_src = ['https://www.google-analytics.com', 'https://pagead2.googlesyndication.com']

Rails.application.config.content_security_policy do |p|
  p.base_uri        :none
  p.default_src     :none
  p.frame_ancestors :none
  p.font_src        :self, assets_host
  p.img_src         :self, :https, :data, :blob, assets_host, *pawoo_img_src
  p.style_src       :self, :unsafe_inline, assets_host
  p.media_src       :self, :https, :data, assets_host
  p.frame_src       :self, :https
  p.manifest_src    :self, assets_host

  if Rails.env.development?
    webpacker_urls = %w(ws http).map { |protocol| "#{protocol}#{Webpacker.dev_server.https? ? 's' : ''}://#{Webpacker.dev_server.host_with_port}" }

    p.connect_src :self, :blob, assets_host, Rails.configuration.x.streaming_api_base_url, *webpacker_urls, *pawoo_connect_src
    p.script_src  :self, :unsafe_inline, :unsafe_eval, assets_host, *pawoo_script_src
  else
    p.connect_src :self, :blob, assets_host, Rails.configuration.x.streaming_api_base_url, *pawoo_connect_src
    p.script_src  :self, assets_host, *pawoo_script_src
  end
end

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
