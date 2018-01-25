module Roadmap
  def get_roadmap
    # The roadmap_id is in the current_enrollment
    current_enrollment = @user['current_enrollment']
    roadmap_id = current_enrollment['roadmap_id']

    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token })

    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(id)
    # get the checkpoint by useing a http get request using the checkpoint id
    # need to get the checkpointid from roadmap object
    # test with id 1844
    response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{id}", headers: { "authorization" => @auth_token })

    @checkpoint = JSON.parse(response.body)
  end
end
