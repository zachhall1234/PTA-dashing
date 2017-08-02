require 'rest-client'
require 'json'
require 'pp'
require 'date'
require 'open-uri'
require 'nokogiri'

performance_platform_url = 'https://www.gov.uk/performance/x-marriage-allowance'

SCHEDULER.every '30s', :first_in => 0 do |dashing_job|
  send_performance_event("user-satisfaction", "user-satisfaction-meter", performance_platform_url)
end

def send_performance_event(xpath_id, widget_id, url)
  page = Nokogiri::HTML(open(url))

  number = page.xpath(".//*[@id='%s']/div/div[1]/div/div[1]/div/strong" % xpath_id).text
  info_text = page.xpath(".//*[@id='%s']/div/div[1]/div/div[1]/div/span" % xpath_id).text

  send_event(widget_id, {current: number, moreinfo: info_text,  status: 'fine'})

end