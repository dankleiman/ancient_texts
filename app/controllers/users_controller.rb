class UsersController < ApplicationController
  def subscribe
    begin
      Gibbon::API.new(ENV['MAILCHIMP_API_KEY']).lists.subscribe({:id => ENV['MAILCHIMP_LIST_ID'], :email => {:email => params[:user][:email]}, :double_optin => false})
      flash[:notice] = "You have successfully subscribed!"
    rescue Gibbon::MailChimpError => e
      flash[:alert] = e.message
    end
    render nothing: true
  end
end
