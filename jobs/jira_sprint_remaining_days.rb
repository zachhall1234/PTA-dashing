# Displays the board name, sprint name and remaining days for the active sprint for a specific board in Jira Agile

require 'net/http'
require 'json'
require 'time'

JIRA_URI = URI.parse("https://jira.tools.tax.service.gov.uk")

# the key of this mapping must be a unique identifier for your board, the according value must be the view id that is used in Jira

view_mapping = {
    'jira-days-left' => 855,
}

# gets the active sprint for the view
def get_active_sprint_for_view(view_id)
  http = create_http
  request = create_request("/rest/greenhopper/1.0/xboard/work/allData/?rapidViewId=%s" % view_id)
  response = http.request(request)
  sprints = JSON.parse(response.body)['sprintsData']['sprints']
  sprints.each do |sprint|
    if sprint['state'] == 'ACTIVE'
      return sprint
    end
  end
end

# create HTTP
def create_http
  http = Net::HTTP.new(JIRA_URI.host, JIRA_URI.port)
  if ('https' == JIRA_URI.scheme)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  return http
end

# create HTTP request for given path
def create_request(path)
  request = Net::HTTP::Get.new(JIRA_URI.path + path)
  request.basic_auth(settings.user, settings.pwd)
  return request
end

view_mapping.each do |view, view_id|
  SCHEDULER.every '1m', :first_in => 0 do |id|
    view_name = ""
    sprint_name = ""
    days = ""
    
    sprint_json = get_active_sprint_for_view(view_id)
   
    begin
      if (sprint_json != nil)
        sprint_name = sprint_json['name']
        end_date = DateTime.strptime(sprint_json['endDate'].to_s,'%d/%b/%y %k:%M %p')
      end

        send_event(view, { title: "%s ends in" % sprint_name, end: end_date })
    rescue Exception
      send_event(view, { title: "No sprint", end: DateTime.now })
    end
  end
end
