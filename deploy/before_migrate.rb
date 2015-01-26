# For AWS OpsWorks
Chef::Log.info("Running deploy/before_migrate.rb...")

Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")

directory "#{new_resource.deploy_to}/shared/assets" do
  owner 'deploy'
  group 'www-data'
  action :create
  recursive true
end

link "#{release_path}/public/assets" do
  to "#{new_resource.deploy_to}/shared/assets"
end

rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for #{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
  only_if { node[:deploy][:release_ninja].fetch(:assets, true) != false  }
end
