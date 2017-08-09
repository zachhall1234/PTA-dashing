require 'net/http'
require 'json'
require 'openssl'

class Repo
  attr_reader :owner, :name, :is_enterprise

  def initialize(owner, name, is_enterprise)
    @owner = owner
    @name = name
    @is_enterprise = is_enterprise
  end
end

def getPRs(repos)
  pull_requests = []

  enterprise_username = 'zach.hall'
  enterprise_token = 'fbb0a0fdc46d8c39aabe73a08a19658e86fd1541'
  open_username = 'zachhall1234'
  open_token = '17d64997a36cf216703174755fac211df7de9c8b'

  repos.each do |repo|
    url = repo.is_enterprise ? "https://github.tools.tax.service.gov.uk/api/v3" : "https://api.github.com"
    parsed_url = URI.parse(url)
    http_client = Net::HTTP.new(parsed_url.host, parsed_url.port)

    username = repo.is_enterprise ? enterprise_username : open_username
    token = repo.is_enterprise ? enterprise_token : open_token

    if 'https' == parsed_url.scheme
      http_client.use_ssl = true
      http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(url + '/repos/' + repo.owner + "/" + repo.name + '/pulls')
    request.basic_auth(username, token)
    response = http_client.request(request)
    json_response = JSON.parse(response.body)
    json_response.each do |pr|
      userRequest = Net::HTTP::Get.new(url + '/users/' + pr['user']['login'])
      userRequest.basic_auth(username, token)
      userResponse = http_client.request(userRequest)
      user = JSON.parse(userResponse.body)

      pull_requests << {
        'repo_name' => pr['base']['repo']['name'],
        'user_name' => user['name'],
        'title' => pr['title'],
        'created_at' => pr['created_at']
      }
    end

  end

  send_event("pull_requests", {items: pull_requests})

end

  
SCHEDULER.every '5s', :first_in => 0 do |dashing_job|
  getPRs([
    Repo.new("hmrc", "pertax-frontend", false),
    Repo.new("hmrc", "pertax-acceptance-tests", true),
    Repo.new("hmrc", "feedback-survey-frontend", false),
    Repo.new("hmrc", "fandf-frontend", true),
    Repo.new("hmrc", "citizen-details", true),
    # Repo.new("zachhall1234", "pertax-frontend", false)
  ])
end

 
