class Api::SystemController < Api::ApiController
  def status
    @status = {
      api_version: "1.0",
      client_version: {
        min: "1.0",
        max: "1.0"
      }
    }
  end
end
