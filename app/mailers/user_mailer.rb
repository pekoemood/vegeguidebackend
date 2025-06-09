class UserMailer < ApplicationMailer
  def email_change_confirm
    @user = params[:user]
    @new_email = params[:new_email]
    @token = params[:token]
    @url = confirm_api_v1_email_change_requests_url(token: @token)
    
    mail(to: @new_email, subject: 'メールアドレス変更の確認')
  end
end
