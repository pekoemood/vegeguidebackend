class UserMailer < ApplicationMailer
  def email_change_confirm
    @user = params[:user]
    @new_email = params[:new_email]
    @token = params[:token]
    @url = Rails.env.production? ? "https://vegeguidefrontend.vercel.app/?token=#{@token}" : "https://localhost:5173/?token=#{@token}"
    
    mail(to: @new_email, subject: 'メールアドレス変更の確認')
  end
end
