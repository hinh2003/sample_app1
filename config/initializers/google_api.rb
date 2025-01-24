# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'google/apis/sheets_v4'

def fetch_google_drive_files(access_token)
  drive_service = Google::Apis::DriveV3::DriveService.new
  drive_service.authorization = access_token

  begin
    response = drive_service.list_files(
      q: "mimeType='application/vnd.google-apps.spreadsheet'",
      fields: 'files(id, name)'
    )
    response.files
  end
end

def fetch_all_sheets_data(file_id, access_token)
  sheets_service = Google::Apis::SheetsV4::SheetsService.new
  sheets_service.authorization = access_token

  begin
    spreadsheet = sheets_service.get_spreadsheet(file_id)

    sheet_data = []

    spreadsheet.sheets.each do |sheet|
      sheet_name = sheet.properties.title
      range = sheet_name.to_s
      response = sheets_service.get_spreadsheet_values(file_id, range)

      sheet_data << { name: sheet_name, data: response.values }
    end
    sheet_data
  end
end
