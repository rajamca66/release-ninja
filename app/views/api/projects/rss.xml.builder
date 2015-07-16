xml.instruct!
xml.rss version: '2.0' do
  xml.channel do
    xml.title @project.title
    xml.description @project.title
    xml.link public_url(Rails.application.default_url_options.merge(id: @project.id))
  end
end
