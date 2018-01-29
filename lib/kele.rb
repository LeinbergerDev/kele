# Kele connects to the bloc.io api to allow for users to interact with the bloc website
# Add require statements for HTTParty and json
require 'HTTParty'
require 'json'
require './lib/roadmap'

class Kele
  # HTTParty needs to be included
  include HTTParty
  include JSON
  include Roadmap
  # set the base_uri for api. Using this was causing an error for port :80.  Try it from homepage
  # it could be caused by the work firewall.
  base_uri = "https://www.bloc.io/api/v1"


  # initialize should require an email and a password.
  # use self.class.post to retrieve the auth_token.
  def initialize(email, password)
    # This gets the response object.  We only want the auth_token from it.  So we will have to
    # query the response for it.
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: email, password: password })
    # query the response object for the auth_token. And assign it to @auth_token.
    @auth_token = response['auth_token']
  end

  def get_me
    # I need to get the current_user by passing the @auth_token as a header.
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })

    # I have a response object.  I need to get the user data from the response object and parse it into a ruby hash
    # Response has 4 attributes.  #body, #headers, #request, #response
    # The body attribute contains the information that I need.
    # first I am going to try using the JSON.parse method and pass it the response.body attribute

    @user = JSON.parse(response.body)

    # in the irb console the @user attribute contains my user data from bloc.io
    # puts @user
    # in the irb console the @user attribute is of a class hash.
    # puts @user.class
  end

  def get_mentor_availability
    # use the mentor id listed in the user data to find the mentors availability
    # this is another get request.
    # get the mentor id
    # note that the @user has is a hash of hashes.  The mentor_id was within the
    # current_enrollment hash.
    current_enrollment = @user['current_enrollment']
    @mentor_id = current_enrollment['mentor_id']

    # use the get method to get a response to our get request
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{@mentor_id}/student_availability", headers: { "authorization" => @auth_token })

    # parse the body to a ruby array.
    @availability = JSON.parse(response.body)
    # verified that the @availability is of class array.
    # puts @availability.class
  end

  def get_messages(page_id = nil)
    address = "https://www.bloc.io/api/v1/message_threads"
    response = self.class.get(address, query: { page: page_id }, headers: { authorization: @auth_token })
    data = JSON.parse(response.body)
    @messages = data
  end


  # k.create_message("jason@leinbergerdev.com", 2290632, "26cf9eb8-87c5-4478-a1ee-f31fc5c32cf6", "test send message api", "this is a test.  should it not be a test importand information would follow." )
  # k.create_message("jason@leinbergerdev.com", 2290632, nil, "test send message api", "this is a test.  should it not be a test importand information would follow." )
  def create_message(sender, recipient_id = nil, token = nil, subject, message)

    address = "https://www.bloc.io/api/v1/messages"
    if token == nil
      puts "token is nill"
      response = self.class.post("https://www.bloc.io/api/v1/messages", body: {sender: sender, recipient_id: recipient_id,  subject: subject, 'stripped-text' => message}, headers: { authorization: @auth_token })
    else
      puts "message has a token"
      response = self.class.post("https://www.bloc.io/api/v1/messages", body: { sender: sender, recipient_id: recipient_id, token: token, subject: subject,  'stripped-text' => message }, headers: { authorization: @auth_token })
    end

  end
end
