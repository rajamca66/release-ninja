class NotesMailer < ActionMailer::Base
  default from: "noreply@therelease.ninja"
  layout 'mail'

  # Updates is hash of {repository => notes added}
  def notify(project, updates)
    @title = "We've Automatically Updated #{project.title}!"
    @project = project
    @notes_added = updates.map{ |r, notes| notes.count }.reduce(&:+)

    emails = project.users.pluck(:email).uniq.reject(&:blank?)
    mail(to: emails, subject: "Release Ninja Updates - #{project.title}")
  end
end
