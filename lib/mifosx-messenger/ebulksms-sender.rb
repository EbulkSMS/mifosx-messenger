require 'httpclient'
require_relative 'message-sender'

module MifosXMessenger
	class EBulkSMSSender < MessageSender
		@uri = nil
		@params = nil
		@client = nil

		def initialize(options = {})
			uri = options['uri'] || 'http://api.ebulksms.com:8080/sendsms'
			@params = options
			@params['flash'] ||= 0
			@params['sender'] ||= 'Mifos SMS'
			@uri = URI.parse(uri)
			@client = Net::HTTP.new(@uri.host, @uri.port)
			if @uri.scheme == 'https'
				@client.use_ssl = true
				@client.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
		end

		def send_sms(number, message)
			params = @params
			params['recipients'] = number
			params['messagetext'] = message
			params.delete('uri')

			querystr = params.map{|k,v|k+'='+v.to_s}.join('&')
                        res = @client.request_get(@uri.request_uri + '?' + URI::escape(querystr))
			puts "SMS Request Sent. Response: " + res.body
		end
	end
end
