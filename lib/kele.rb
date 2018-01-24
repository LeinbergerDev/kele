class Kele
  include HTTParty

  base_url = "https://www.bloc.io/api/v1"

  def initialize(email, password)

    @auth_token = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: email, password: password })

    puts @auth_token
  end


end
