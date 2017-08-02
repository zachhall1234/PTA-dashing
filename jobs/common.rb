def json_from_url(url)
  parsed_url = URI.parse(url)
  http = Net::HTTP.new(parsed_url.host, parsed_url.port)
  if 'https' == parsed_url.scheme
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  request = Net::HTTP::Post.new(parsed_url.request_uri)
  request.basic_auth(settings.user, settings.pwd)
  result = http.request(request)
  begin
    json = JSON.parse(result.body)
    #puts json
    json
  rescue Exception => ex
    print ex.message, ex.backtrace.inspect
     JSON.parse("{}")
  end
end

def default_if_missing(val, &proc)
  begin
    proc.call
  rescue NoMethodError
    val
  end
end
