# config/initializers/secrets.rb
module Secrets
  def self.fetch(key, default = nil)
    env_key_lower = key.to_s.downcase
    credentials_key = env_key_lower.to_sym
    env_key_upper = env_key_lower.upcase

    Rails.application.credentials[credentials_key] ||
      ENV[env_key_upper] ||
      ENV[env_key_lower] ||
      default
  end
end
