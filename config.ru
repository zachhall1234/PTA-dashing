require 'sinatra/config_file'
require 'sinatra/cyclist'
require 'dashing'

configure do
  set :jenkins, {
      'urls'  => ['https://deploy-qa-left.tax.service.gov.uk/view/PERTAX','https://ci-open.tax.service.gov.uk/view/PERTAX-MONITOR']
  }
  set :jenkinsperf, 'https://deploy-staging-left.tax.service.gov.uk'
  set :jenkinsdev, 'https://ci-dev.tax.service.gov.uk'
  set :jenkinsopen, 'https://ci-open.tax.service.gov.uk'
  set :jenkinsqa, 'https://deploy-qa-left.tax.service.gov.uk'

  config_file 'config.yml'
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

Sinatra::Application.settings.history.clear

run Sinatra::Application
