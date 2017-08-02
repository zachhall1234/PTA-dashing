require 'net/http'
require 'json'

http_client = nil
last_build_procs = nil

SCHEDULER.every '60s', :first_in => 0 do |dashing_job|
  unless defined? settings.jenkinsperf?
    return
  end
  
  doJenkinsUpdate("tcs-perf",settings.jenkinsperf.chomp('/'),'tcs-performance-tests')
  doJenkinsUpdate("jenkins-fandf",settings.jenkinsdev.chomp('/'),'fandf-frontend')
  doJenkinsUpdate("jenkins-citizen-details",settings.jenkinsdev.chomp('/'),'citizen-details')
  doJenkinsUpdate("jenkins-assets-frontend",settings.jenkinsopen.chomp('/'),'tax-credits-submissions')
  doJenkinsUpdate("jenkins-pertax-frontend",settings.jenkinsopen.chomp('/'),'pertax-frontend')
  doJenkinsUpdate("jenkins-fandf-frontend",settings.jenkinsdev.chomp('/'),'fandf-frontend')
  doJenkinsUpdate("jenkins-fandf-acceptance-tests",settings.jenkinsdev.chomp('/'),'fandf-acceptance-tests')
  doJenkinsUpdate("jenkins-pertax-acceptance-tests",settings.jenkinsdev.chomp('/'),'pertax-acceptance-tests')
  doJenkinsUpdate("jenkins-staging-healthcheck",settings.jenkinsperf.chomp('/'),'tcs-health-check')
  doJenkinsUpdate("jenkins-dev-healthcheck",settings.jenkinsdev.chomp('/'),'tcs-health-check-dev')
  doJenkinsUpdate("jenkins-qa-healthcheck",settings.jenkinsqa.chomp('/'),'tcs-smoke-tests-qa')

end

def doJenkinsUpdate(event_name, jenkins_url, job_name)
  http_client = buildHttpClient(jenkins_url)

  nisp_frontend_api_url = '%s/job/%s/api/json' % [jenkins_url, job_name]

  last_build_procs = [buildProc(http_client, nisp_frontend_api_url)]

  nisp_frontend_build_url = last_build_procs[0].call

  begin

    nisp_frontend_results = callJenkins(http_client, nisp_frontend_build_url)
    if nisp_frontend_results[2] == nil
      send_event(event_name, { result: "Status: BUILDING (#%s)" % [nisp_frontend_results[3]],
        timestamp: "Started at: %s" % Time.at(nisp_frontend_results[1]/1000).strftime("%H:%M %P"),
        duration: "",
        status: "building"})
    else
      send_event(event_name, { result: "Status: %s (#%s)" % [nisp_frontend_results[2],nisp_frontend_results[3]],
        timestamp: "Ran on: %s" % Time.at(nisp_frontend_results[1]/1000).strftime("%d/%m/%Y %H:%M %P"),
        duration: "Duration: %s mins" % (nisp_frontend_results[0]/1000/60),
        status: nisp_frontend_results[2].downcase})
    end

  rescue Exception => e
    puts e.backtrace
  end

end

def buildHttpClient(url)
  parsed_url = URI.parse(url)
  http = Net::HTTP.new(parsed_url.host, parsed_url.port)
  if 'https' == parsed_url.scheme
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  http
end

def buildProc(http_client, url)
  Proc.new {
    begin
      response = http_client.request(Net::HTTP::Get.new(url))
      JSON.parse(response.body)['lastBuild']['url']
    rescue Exception => e
      puts e.backtrace
    end
  }
end

def callJenkins(http_client, url)
  response = http_client.request(Net::HTTP::Get.new('%s/api/json' % url.chomp('/')))
  json_response = JSON.parse(response.body)
  [json_response['duration'],json_response['timestamp'],json_response['result'],json_response['number']]
end
