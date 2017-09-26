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
# update_analytics()
GaCallsCount = 0

# # Start the scheduler
SCHEDULER.every '3600s', :first_in => 0 do |dashing_job|
  update_analytics()
  GaCallsCount = GaCallsCount
end

def update_analytics()
  analytics = Analytics.letsgo

   begin

    ### Total Sessions
       
    totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:sessions")
    
    totalVisitsCount = 0
    if totalVisits.total_results > 0
       totalVisitsCount = totalVisits.rows[0][0]
    end    

    send_event('session_count_total', {current: totalVisitsCount.to_i, status: 'fine'})
       
    ###Total Address changes

    totalAddressChanges = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="today", end_date="today", metrics = "ga:goal19Completions")
       
    totalAddressChangesCount = 0
    if totalAddressChanges.total_results > 0
    totalAddressChangesCount= totalAddressChanges.rows[0][0]
    end    
    send_event('TotalAddressChange', {current: totalAddressChangesCount.to_i, status: 'fine'})
    
    ###Total Address changes yesterday

    totalAddressChanges = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="yesterday", end_date="yesterday", metrics = "ga:goal19Completions")
       
    totalAddressChangesCount = 0
    if totalAddressChanges.total_results > 0
    totalAddressChangesCount= totalAddressChanges.rows[0][0]
    end    
    send_event('TotalAddressChangeYesterday', {current: totalAddressChangesCount.to_i, status: 'fine'})

    ###DeskProButton Clicks today

    deskProClicks = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="today", end_date="today", metrics = "ga:uniqueEvents", filters: "ga:eventLabel==Get help with this page Submit")

    deskProClicksTotal = 0
    if deskProClicks.total_results > 0
      deskProClicksTotal = deskProClicks.rows[0][0]
    end
    send_event('deskProClick', {current: deskProClicksTotal.to_i, status: 'fine'})
     ###DeskProButton Clicks yesterday

    deskProClicks = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="yesterday", end_date="yesterday", metrics = "ga:uniqueEvents", filters: "ga:eventLabel==Get help with this page Submit")
    
    deskProClicksTotal = 0
    if deskProClicks.total_results > 0
      deskProClicksTotal = deskProClicks.rows[0][0]
    end
    send_event('deskProClickYesterday', {current: deskProClicksTotal.to_i, status: 'fine'})
    
  end

  # Start the scheduler for real time GA events
  SCHEDULER.every '60s', :first_in => 0 do |dashing_job|
  update_analytics_Active()
end

def update_analytics_Active()
  analytics = Analytics.letsgo

   begin
    
    ### Real Time
    visits = analytics.get_realtime_data(ids = "ga:#{settings.gaprofileid}", metrics = "ga:activeVisitors")

    visitorCount = 0

    if visits.total_results > 0 
      visitorCount = visits.rows[0][0]  
    end

    # Update the dashboard
    send_event('visitor_count_real_time', {current: visitorCount.to_i, status: 'fine'})

    end
  end
end
