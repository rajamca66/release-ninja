class Public::NotesController < Public::BaseController
  def show
    @project = project
    @grouped_notes = grouped_notes
  end

  private

  def project
    @project ||= Project.find(params[:id])
  end

  def notes
    project.notes.where(published: true).where.not(published_at: nil)
  end

  def notes_by_day
    @notes_by_day ||= notes.order(published_at: :desc).group_by{ |note| note.published_at.to_date }
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
