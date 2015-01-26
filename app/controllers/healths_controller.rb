class HealthsController < ApplicationController
  skip_before_filter :ensure_authentication_token

  def show
    if ActiveRecord::Migrator.current_version > 0
      render status: :ok, text: "OK"
    else
      render status: :internal_server_error, text: "Internal Server Error"
    end
  end
end
