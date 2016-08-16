class Site::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_for_invite
  respond_to :json

  def project
    @project ||= Project.find(params.fetch(:site_id))
  end

  before_filter :set_format

  def set_format
    request.format = :json
  end
end
