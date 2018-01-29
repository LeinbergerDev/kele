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
# k.create_checkpoint_submission("")
  def create_checkpoint_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions", values: {assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, comment: comment, enrollment_id: enrollment_id}, headers: { "authorization" => @auth_token } )
    @submission = JSON.parse(response.body)
  end
end
