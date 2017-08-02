require 'jira'

SCHEDULER.every '10s', :first_in => 0 do |job|
  client = JIRA::Client.new({
    :username => settings.user,
    :password => settings.pwd,
    :site => "https://jira.tools.tax.service.gov.uk",
    :auth_type => :basic,
    :context_path => ""
  })

    closed_points = client.Issue.jql("project = OPP and sprint in openSprints() and status = \"qa in progress\" or status = \"qa ready\"").size || 0
    total_points = client.Issue.jql("project = OPP and sprint in openSprints()").size || 0
  if total_points == 0
    percentage = 0
    moreinfo = "No sprint currently in progress"
  else
    percentage = ((closed_points.to_f/total_points.to_f)*100).to_i
    moreinfo = "#{closed_points.to_i} / #{total_points.to_i}"
  end

    send_event('p800-payments-qa', { title: "Tickets In QA", min: 0, value: percentage, max: 100, moreinfo: moreinfo })
    
end