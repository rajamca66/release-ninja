xml.instruct!
xml.rss version: '2.0' do
  xml.channel do
    xml.title @project.title
    xml.description @project.title
    xml.link public_rss_url(Rails.application.default_url_options.
      merge(id: @project.friendly_id)
    )
    @project.notes.each do |note|
      next unless note.published?
      xml.item do
        xml.title note.title
        xml.description note.markdown_body
        xml.pubDate note.published_at.rfc822()
      end
    end
  end
end
