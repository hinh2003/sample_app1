# frozen_string_literal: true

# this is GoogleSheetsController
class GoogleSheetsController < ApplicationController
  before_action :ensure_google_access, only: %i[index show]

  def index
    @google_sheets_files = fetch_google_drive_files(current_user.google_access_token)
  end

  def show
    file_id = params[:id]
    @sheet_data = fetch_all_sheets_data(file_id, current_user.google_access_token)
  end

  private

  def ensure_google_access
    if current_user.google_access_token.nil?
      session[:redirect_after_google_auth] = request.fullpath
      flash[:info] = 'Vui lòng kết nối tài khoản Google để truy cập dữ liệu.'
      redirect_to root_path
    elsif current_user.google_token_expires_at?
      current_user.refresh_google_token
    end
  end
end
