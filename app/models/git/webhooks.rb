Git::Webhooks = Struct.new(:user, :repository) do
  def ninja_hooks(host: Rails.application.routes.default_url_options[:host])
    list.select{ |h| h[:config][:url].try!(:include?, host) }
  end

  def ensure_hook(url, events, active: false)
    hook_options = {
      url: url,
      content_type: "json"
    }

    user.github.create_hook(repository.full_name, "web", hook_options, events: events, active: active)
  end

  private

  def list
    @list ||= user.github.hooks(repository.full_name, auto_paginate: true)
  end
end
