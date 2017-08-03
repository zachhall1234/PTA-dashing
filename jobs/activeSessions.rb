require 'google/apis/analytics_v3'
require 'date'
require 'pp'
require 'json'

class Analytics 
  Analytics = Google::Apis::AnalyticsV3

  def self.letsgo

    # Get the Google API client
    analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
    # Get the environment configured authorization
      scopes = ['https://www.googleapis.com/auth/analytics']
      authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open("keyfile.json"), scope: scopes)
      visitors = []

      analytics.authorization = authorization

      return analytics
  end
end
# Start the scheduler
SCHEDULER.every '30s', :first_in => 0 do |dashing_job|
  update_analytics()
end

def update_analytics()
  analytics = Analytics.letsgo

   begin
    
    ### Real Time
    # Execute the query
    visits = analytics.get_realtime_data(ids = "ga:#{settings.gaprofileid}", metrics = "ga:activeVisitors")

    visitorCount = 0

    if visits.total_results > 0 
      visitorCount = visits.rows[0][0]  
    end

    # Update the dashboard
    send_event('visitor_count_real_time!!', {current: visitorCount.to_i, status: 'fine'})
end

end