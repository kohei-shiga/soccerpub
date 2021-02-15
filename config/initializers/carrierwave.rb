require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  unless Rails.env.test?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: Rails.application.credentials.aws[:s3][:region]
    }
    
    config.cache_storage = :fog
    config.fog_directory = Rails.application.credentials.aws[:s3][:bucket]
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/soccerpub-activestorage-bucket'
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end