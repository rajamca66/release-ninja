class Public::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token

  layout "public"
end
