require 'pp'
require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

SCHEDULER.every '10s', :first_in => 0 do |dashing_job|
  send_releases_event('fandf-frontend-releases', 'fandf-frontend')
  send_releases_event('pertax-frontend-releases', 'pertax-frontend')
  send_releases_event('frontend-template-provider-releases', 'frontend-template-provider')
  send_releases_event('feedback-survey-frontend-releases', 'feedback-survey-frontend')
end


def send_releases_event(event_name, service_name)
  page = Nokogiri::HTML(open("https://releases.tax.service.gov.uk/whats-running-where"))   
  puts page.xpath

  qa = page.xpath(".//*[@id='running_apps']/tbody/tr[./td/text()='%s']/td[3]" % service_name).text
  staging = page.xpath(".//*[@id='running_apps']/tbody/tr[./td/text()='%s']/td[6]" % service_name).text
  prod = page.xpath(".//*[@id='running_apps']/tbody/tr[./td/text()='%s']/td[8]" % service_name).text
  
  send_event(event_name, 
    { 
      result: "QA: %s" % qa,
      timestamp: "Staging: %s" % staging,
      duration: "Prod: %s" % prod
    }
  )
end 
