#require 'hashie'
require 'json'

class Sms
    # CONSTANTS
    URL = 'http://devapi.globelabs.com.ph/smsmessaging/%s/outbound/%s/requests'
	
    # CLASS VARIABLES
    @@shortCode   = String.new
    @@version     = 'v1'
	
    # Initialize Access Token and Short Code
    def initialize(shortCode)
        @@shortCode   = shortCode
    end
	
    # Sends an SMS
    #
    # * Sets the string query for the parameters
    # * Sends data using POST METHOD
    def sendMessage(accessToken, subscriber, message)
        #Build HTTP parameters for access token
        token = { 'access_token' => accessToken }
        query  = URI.encode_www_form(token)
		
        #Setting up the request URL
        requestUrl = sprintf(URL, @@version, @@shortCode)
        requestUrl = requestUrl+'?'+query
		
        #Request as POST METHOD
        uri       = URI.parse(requestUrl)
        http      = Net::HTTP.new(uri.host, uri.port)
        request   = Net::HTTP::Post.new(requestUrl)
		
	#POST Parameters
        params = {
            'address' => subscriber,
            'message' => message
        }
		
        request.set_form_data(params)
		
        response  = http.request(request)
		
        return response.body
    end
	
    # Set the API version
    def setVersion(version)
        @@version = version
        return self 
    end

    # Parse SMS
    def method_name
    #Subscriber number
      msisdn = params['inboundSMSMessageList']['inboundSMSMessage'].first['senderAddress']
      @@msisdn = msisdn[7..msisdn.length]
    end

end
