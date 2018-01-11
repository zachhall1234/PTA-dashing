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
    
    ###DeskProButton Clicks Yesterday

    deskProClicks = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="yesterday", end_date="yesterday", metrics = "ga:uniqueEvents", filters: "ga:eventLabel==Get help with this page Submit")
    
    deskProClicksTotal = 0
    if deskProClicks.total_results > 0
      deskProClicksTotal = deskProClicks.rows[0][0]
    end
    send_event('deskProClickYesterday', {current: deskProClicksTotal.to_i, status: 'fine'})

    ### TOTAL AMBIGUOUS SESSIONS YESTERDAY
       
    ambiguousSessionsYesterday = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="yesterday", end_date="yesterday",  metrics = "ga:uniquepageviews", filters: "ga:pagepath==/personal-account/self-assessment")
    
    ambiguousSessionsYesterdayCount = 0
    if ambiguousSessionsYesterday.total_results > 0
       ambiguousSessionsYesterdayCount = ambiguousSessionsYesterday.rows[0][0]
    end    

    send_event('AmbiguousSessionsYesterday', {current: ambiguousSessionsYesterdayCount.to_i, status: 'fine'})

    ### TOTAL AMBIGUOUS SESSIONS TODAY
       
    ambiguousSessionsToday = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:uniquepageviews", filters: "ga:pagepath==/personal-account/self-assessment")
    
    ambiguousSessionsTodaydayCount = 0
    if ambiguousSessionsToday.total_results > 0
       ambiguousSessionsTodayCount = ambiguousSessionsToday.rows[0][0]
    end    

    send_event('AmbiguousSessionsToday', {current: ambiguousSessionsTodayCount.to_i, status: 'fine'})

    ### TOTAL SA FILE CLICKS YESTERDAY
       
    saFileClicksYesterday = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="yesterday", end_date="yesterday",  metrics = "ga:uniqueevents", filters: "ga:eventlabel==Complete 2016 to 2017 tax return")
    
    saFileClicksYesterdayCount = 0
    if saFileClicksYesterday.total_results > 0
       saFileClicksYesterdayCount = saFileClicksYesterday.rows[0][0]
    end    

    send_event('saFileClicksYesterday', {current: saFileClicksYesterdayCount.to_i, status: 'fine'})

    ### TOTAL SA FILE CLICKS TODAY
       
    saFileClicksToday = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:uniqueevents", filters: "ga:eventlabel==Complete 2016 to 2017 tax return")
    
    saFileClicksTodayCount = 0
    if saFileClicksToday.total_results > 0
       saFileClicksTodayCount = saFileClicksToday.rows[0][0]
    end    

    send_event('saFileClicksToday', {current: saFileClicksTodayCount.to_i, status: 'fine'})
  
  end

  # Start the scheduler for real time GA events
  SCHEDULER.every '60s', :first_in => 0 do |dashing_job|
  update_analytics_Active()
end

def update_analytics_Active()
  analytics = Analytics.letsgo

   begin
    
    ### Real Time Active Users
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
