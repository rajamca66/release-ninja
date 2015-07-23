xml.instruct!
xml.rss version: '2.0' do
  xml.channel do
    xml.title @project.title
    xml.description @project.title
    xml.link public_rss_url(id: @project.friendly_id)

    @notes.each do |note|
      next unless note.published?
      xml.item do
        xml.title note.title
        xml.description note.html_body
        xml.pubDate note.published_at.rfc822
      end
    end
  end
end
