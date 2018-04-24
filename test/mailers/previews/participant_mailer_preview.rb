# Preview all emails at http://localhost:3000/rails/mailers/participant_mailer
class ParticipantMailerPreview < ActionMailer::Preview
  def auction_summary_preview
    ParticipantMailer.with(user: User.first).auction_summary("test@email.com")
  end
end
