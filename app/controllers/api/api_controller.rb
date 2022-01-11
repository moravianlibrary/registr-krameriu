class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  after_action :skip_session
  before_action :set_headers

  private

    def render_404
    	render status: 404, json: { message: "Not Found" }
    end

    def set_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
    end

    def skip_session
      request.session_options[:skip] = true
    end

    def render_error(msg)
      render json: {
        error: msg
      }, status: :unprocessable_entity
    end

end
