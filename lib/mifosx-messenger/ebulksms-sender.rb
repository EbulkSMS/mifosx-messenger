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

			client = HTTPClient.new(:agent_name => 'MifosWebAppRuby/0.1')
			client.post(@uri, params)
		end
	end
end
