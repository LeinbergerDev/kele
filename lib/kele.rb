# Kele connects to the bloc.io api to allow for users to interact with the bloc website
# Add require statements for HTTParty and json
require 'HTTParty'
require 'json'

class Kele
  # HTTParty needs to be included
  include HTTParty
  include JSON
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
end
