NoteGrouper = Struct.new(:notes) do
  def call
    grouped_notes
  end

  private

  def notes_by_day
    @notes_by_day ||= notes.group_by do |note|
      note.published_at ? note.published_at.to_date : note.created_at.to_date
    end.sort.reverse
  end

  def grouped_notes
    {}.tap do |results|
      notes_by_day.each do |date, notes|
        results[date] = notes.group_by(&:level).sort_by{ |s, n| severity_order.index(s) }
      end
    end
  end

  def severity_order
    [Note::MAJOR, Note::MINOR, Note::FIX]
  end
end
