Git::Webhooks = Struct.new(:user, :repository) do
  def ninja_hook(host: Rails.application.routes.default_url_options[:host])
    list.select{ |h| h[:config][:url].try!(:include?, host) }.first
  end

  def ensure_hook(url)
    hook_options = {
      url: url,
      content_type: "json"
    }

    user.github.create_hook(repository.full_name, "web", hook_options, events: ["pull_request"])
    ninja_hook
  end

  private

  def list
    user.github.hooks(repository.full_name, auto_paginate: true).map do |h|
      h[:repo] = repository.full_name
      h[:repo_id] = repository.id
      h.to_h
    end
  end
end
