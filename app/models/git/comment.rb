Git::Comment = Struct.new(:body) do
  HEADERS = {
      "# Fix" => :fix,
      "# Bug Fix" => :fix,
      "# New Feature" => :feature,
      "# Major Feature" => :feature,
      "# Feature" => :feature,
      "## Fix" => :fix,
      "## Bug" => :fix,
      "## Bug Fix" => :fix
  }
  # Bug Fix, # New Feature, # Major Feature

  def release_note?
    type != nil
  end

  def type
    HEADERS.each do |header, type|
      return type if body.present? && body.starts_with?(header)
    end

    nil
  end

  def title
    @title ||= if release_note?
      title_line = body.split("\n").first
      title_line.split("-").drop(1).join("-").strip
    end
  end

  def note_body
    @body ||= if release_note?
      body_without_title = body.split("\n").drop(1)
      body_without_title.join("\n").strip
    end
  end

  def as_json
    {
        type: type,
        title: title,
        body: note_body
    }
  end

  def as_params
    {
        level: type,
        title: title,
        markdown_body: note_body
    }
  end
end
