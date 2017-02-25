require 'httpclient'
require_relative 'message-sender'

module MifosXMessenger
	class EBulkSMSSender < MessageSender
		@uri = nil
		@params = nil

		def initialize(options = {})
			@uri = options['uri'] || 'http://api.ebulksms.com:8080/sendsms'
			@params = options
			@params['flash'] ||= 0
			@params['sender'] ||= 'Mifos SMS'
		end

		def send_sms(number, message)
			params = @params
			params['recipients'] = number
			params['messagetext'] = message

			client = HTTPClient.new(:agent_name => 'Mifos WebHook/0.1')
			querystr = params.map{|k,v|k+'='+v.to_s}.join('&')
			res = @client.request_get(@uri.request_uri + '?' + querystr)
			puts "SMS Request Sent. Response: " + res.body
		end
	end
end
