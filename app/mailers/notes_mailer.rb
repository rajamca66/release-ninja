class NotesMailer < ActionMailer::Base
  default from: "noreply@therelease.ninja"
  layout 'mail'

  # Updates is hash of {repository => notes added}
  def notify(project, updates)
    @title = "We've Automatically Updated #{project.title}!"
    @project = project
    @notes_added = updates.map{ |r, notes| notes.count }.reduce(&:+)

    emails = project.users.pluck(:mailing_email).uniq.reject(&:blank?)
    mail(to: emails, subject: "Release Ninja Updates - #{project.title}")
  end

  def reviewer(project, note, user_who_opened, to:)
    @project = project
    @note = note
    emails = [to]
    emails << user_who_opened.mailing_email if user_who_opened.try!(:mailing_email)

    mail(to: emails, subject: "[RELEASE NINJA] New Release Ready")
  end
end
