class Site::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_for_invite
  after_filter :cors_set_access_control_headers
  respond_to :json

  def project
    @project ||= Project.find(params.fetch(:site_id))
  end

  before_filter :set_format

  def set_format
    request.format = :json
  end

  def cors_set_access_control_headers
    origin = request.headers["Origin"]
    return unless origin.present? && project.origin_list.include?(origin)

    headers['Access-Control-Allow-Origin'] = origin
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = "1728000"
  end
end
