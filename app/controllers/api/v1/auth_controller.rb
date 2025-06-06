require "googleauth/id_tokens"
require "httparty"

class Api::V1::AuthController < ApplicationController

  def google_login
    auth_code = params[:code]
    if auth_code.blank?
      return render json: { error: '認証コードが見つかりません' }, status: :bad_request
    end

    begin
      response = HTTParty.post("https://oauth2.googleapis.com/token", 
      headers: { "Content-Type" => "application/x-www-form-urlencoded"},
      body: {
        code: auth_code,
        client_id: Rails.application.credentials.google[:client_id],
        client_secret: Rails.application.credentials.google[:client_secret],
        redirect_uri: Rails.application.credentials.frontend_origin,
        grant_type: "authorization_code"
        }
      )

      unless response.success?
        Rails.logger.error("Googleトークン取得失敗: #{response.body}")
        return render json: { error: 'Googleトークンの取得に失敗しました' }, status: :unprocessable_entity
      end

      id_token = response.parsed_response["id_token"]

      payload = Google::Auth::IDTokens.verify_oidc(
        id_token,
        aud: Rails.application.credentials.google[:client_id]
      )
      
      unless payload
        return render json: { error: '無効なIDトークンです' }, status: :unauthorized
      end

      user = User.find_or_initialize_by(google_uid: payload["sub"])
      user.email = payload["email"]
      user.name = payload["name"]

      unless user.persisted?
        user.password = SecureRandom.hex(10)
      end

      if user.save
        token = TokenGenerator.encode(user.id)
        cookies[:jwt] = {
        value: token,
        expires: 24.hours.from_now,
        secure: Rails.env.production?,
        httponly: true,
        same_site: :none,
        path: '/',
        domain: Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
      }

      render json: { status: "ユーザーの登録に成功しました", name: user.name, email: user.email }
      else
      Rails.logger.error("ユーザー保存エラー: #{user.errors.full_messages.join(', ')}")
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end

    rescue Google::Auth::IDTokens::VerificationError => e
      Rails.logger.warn "IDトークンの検証に失敗しました: #{e.message}"
      render json: { error: '認証エラー: 無効なIDトークンです' }, status: :unauthorized
    rescue Google::Apis::ClientError => e
      # Google API との通信エラー (例: 認証コードが無効、redirect_uri 不一致など)
      Rails.logger.error "Google API通信エラー: #{e.message}, Received Code: #{auth_code}"
      render json: { error: "Google認証中にエラーが発生しました: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      # その他の予期せぬエラー
      Rails.logger.error "予期せぬエラーが発生しました: #{e.message}, Backtrace: #{e.backtrace.join("\n")}"
      render json: { error: "サーバー内部エラーが発生しました" }, status: :internal_server_error
    end
  end
end
