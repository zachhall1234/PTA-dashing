# require 'google/apis/analytics_v3'
# require 'date'
# require 'pp'
# require 'json'

# class Analytics 
# #   Analytics = Google::Apis::AnalyticsV3

#   def self.letsgo

#     # Get the Google API client
#     analytics = Google::Apis::AnalyticsV3::AnalyticsService.new
#     # Get the environment configured authorization
#       scopes = ['https://www.googleapis.com/auth/analytics']
#       authorization = Google::Auth::ServiceAccountCredentials.make_creds(
#         json_key_io: File.open("keyfile.json"), scope: scopes)
#       visitors = []

#       analytics.authorization = authorization

#       return analytics
#   end
# end
# # update_analytics()


# # # Start the scheduler
# SCHEDULER.every '30s', :first_in => 0 do |dashing_job|
#   update_analytics()
# end

# def update_analytics()
#   analytics = Analytics.letsgo

#    begin
    
#     # ### Real Time
#     # # Execute the query
#     # visits = analytics.get_realtime_data(ids = "ga:#{settings.gaprofileid}", metrics = "ga:activeVisitors")

#     # visitorCount = 0

#     # if visits.total_results > 0 
#     #   visitorCount = visits.rows[0][0]  
#     # end

#     # # Update the dashboard
#     # send_event('visitor_count_real_time', {current: visitorCount.to_i, status: 'fine'})

#     ### application journey today
#        totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:goal13completions")
    
#     totalVisitsCount = 0
#     if totalVisits.total_results > 0
#        totalVisitsCount = totalVisits.rows[0][0]
#     end    

#        send_event('successful_applications', {current: totalVisitsCount.to_i, status: 'fine'})

#     ### Total apps
#         totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="2015-04-01", end_date="today",  metrics = "ga:goal1completions")

#     totalVisitsCount = 0
#     if totalVisits.total_results > 0
#           totalVisitsCount = totalVisits.rows[0][0]
#     end

#        send_event('successful_applications_total', {current: totalVisitsCount.to_i, status: 'fine'})
       
#     ###  coc today
#     totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:goal12completions")
    
#     totalVisitsCount = 0
#     if totalVisits.total_results > 0
#        totalVisitsCount = totalVisits.rows[0][0]
#     end    

#        send_event('successful_coc', {current: totalVisitsCount.to_i, status: 'fine'})


#     ### Total coc
#     totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="2015-01-01", end_date="today",  metrics = "ga:goal12completions")

#     totalVisitsCount = 0
#     if totalVisits.total_results > 0
#        totalVisitsCount = totalVisits.rows[0][0]
#     end

#        send_event('successful_coc_total', {current: totalVisitsCount.to_i, status: 'fine'})

#        ### Total Sessions
       
#     totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:sessions")
    
#     totalVisitsCount = 0
#     if totalVisits.total_results > 0
#        totalVisitsCount = totalVisits.rows[0][0]
#     end    

#     send_event('session_count_total', {current: totalVisitsCount.to_i, status: 'fine'})
       
#     ### avg sessions per user
       
#     totalVisits = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="2015-01-01", end_date="today",  metrics = "ga:sessionsPerUser")
    
#        totalVisitsCount = 0
#        if totalVisits.total_results > 0
#        totalVisitsCount = totalVisits.rows[0][0]
#        end    
  
#     send_event('sessions_per_user', {current: totalVisitsCount.to_i, status: 'fine'})
       
#     ###Total Address changes

#     totalAddressChanges = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="today", end_date="today", metrics = "ga:goal19Completions")
       
#     totalAddressChangesCount = 0
#     if totalAddressChanges.total_results > 0
#     totalAddressChangesCount= totalAddressChanges.rows[0][0]
#     end    
#     send_event('TotalAddressChange', {current: totalAddressChangesCount.to_i, status: 'fine'})
    
#     ###Total Address changes yesterday

#     totalAddressChanges = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="yesterday", end_date="yesterday", metrics = "ga:goal19Completions")
       
#     totalAddressChangesCount = 0
#     if totalAddressChanges.total_results > 0
#     totalAddressChangesCount= totalAddressChanges.rows[0][0]
#     end    
#     send_event('TotalAddressChangeYesterday', {current: totalAddressChangesCount.to_i, status: 'fine'})

#     ###DeskProButton Clicks today

#     deskProClicks = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="today", end_date="today", metrics = "ga:uniqueEvents", filters: "ga:eventLabel==Get help with this page Submit")

#     deskProClicksTotal = 0
#     if deskProClicks.total_results > 0
#       deskProClicksTotal = deskProClicks.rows[0][0]
#     end
#     send_event('deskProClick', {current: deskProClicksTotal.to_i, status: 'fine'})
#      ###DeskProButton Clicks yesterday

#     deskProClicks = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="yesterday", end_date="yesterday", metrics = "ga:uniqueEvents", filters: "ga:eventLabel==Get help with this page Submit")
    
#     deskProClicksTotal = 0
#     if deskProClicks.total_results > 0
#       deskProClicksTotal = deskProClicks.rows[0][0]
#     end
#     send_event('deskProClickYesterday', {current: deskProClicksTotal.to_i, status: 'fine'})
    
#     ###Session average duration
       
#     sessionAvg = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_data="today", end_date="today", metrics = "ga:avgSessionDuration")
       
#     sessionAvgFloat = 0
       
#     # Gets avg duration from ga as float
#      if sessionAvg.total_results > 0
#         sessionAvgFloat = sessionAvg.rows[0][0]
#      end
       
#     # converts float to int
#     sessionAvgInt = sessionAvgFloat.to_i
       
#     avgDuration = Time.at(sessionAvgInt).utc.strftime("%M:%S")   
       
#     send_event('session_avg', {current: avgDuration, status: 'fine'}) 
       
#     ###Bounce rate as a % of total
#     percentage = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:bounceRate")
            
#     if percentage.total_results > 0
#        percentageOfTotal = percentage.rows[0][0].to_f
#     end
       
#     percentageString = percentageOfTotal.to_s[0..3] + "%"
       
#     send_event('percentage', {current: percentageString, status: 'fine'})
       
#     ### Percentage new users
       
#     percentage = analytics.get_ga_data(id = "ga:#{settings.gaprofileid}", start_date="today", end_date="today",  metrics = "ga:percentNewSessions")
            
#     if percentage.total_results > 0
#        percentageOfTotal = percentage.rows[0][0].to_f
#     end
       
#     percentageString = percentageOfTotal.to_s[0..3] + "%"
       
#     send_event('percentage_new_users', {current: percentageString, status: 'fine'})
       
#   end

# end