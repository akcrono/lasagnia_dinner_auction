class ParticipantMailer < ApplicationMailer
  default from: 'basic.auction@gmail.com'
  
  def auction_summary(email)
    @user = params[:user]
    attachments[@user.csv_filename] = @user.to_csv
    if @user.paid?
      @message = "Thank you for your total payment of #{User.number_to_currency(@user.total_purchased)}."
    else
      @message = "Please pay #{User.number_to_currency(@user.total_due)}."
    end
    mail(to: email, subject: 'Your Auction Summary')
  end
end
