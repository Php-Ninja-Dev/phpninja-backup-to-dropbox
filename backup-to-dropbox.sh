#!/bin/bash
# Php Ninja Website Backup & upload to dropbox
# developers@phpninja.es
#
# Description
# This script will do a zip of the target folder and dump the MySQL database with mysqldump, then will upload both files to Dropbox
#

# MySQL Credentials
db_user="DB USER"
db_password="DB PASSW"
db_name="DB NAME"
db_host="DB HOST"
db_port="3306"

# Dropbox API Access Token
dropbox_token="YOUR DROPBOX TOKEN"
hostname="THIS IS THE NAME OF THE FUTURE FOLDER IN DROPBOX"

# Backup Folder and Zip File
backup_date=$(date +%Y-%m-%d_%H:%M:%S)
target_folder="www"
zip_file="backup_${hostname}_${backup_date}.zip"
sql_file="database_${hostname}_${backup_date}.sql"

# Backup MySQL Database
mysqldump -h "${db_host}" -P "${db_port}" -u "${db_user}" -p"${db_password}" "${db_name}" --no-tablespaces > "${sql_file}"

# Zip the www/ folder
zip -r "${zip_file}" "${target_folder}" -x "cache/*" "tmp/*" ".git/*" "git/*" "ninja/*" 

# Dropbox Upload Function
upload_to_dropbox() {
    local source_file="$1"
    local dropbox_path="/${hostname}/${backup_date}/${source_file}"
    local dropbox_api_url="https://content.dropboxapi.com/2/files/upload"
	  echo "${dropbox_path}"
    curl -X POST "${dropbox_api_url}" \
         --header "Authorization: Bearer ${dropbox_token}" \
         --header "Content-Type: application/octet-stream" \
         --header "Dropbox-API-Arg: {\"path\":\"${dropbox_path}\", \"mode\":\"add\"}" \
         --data-binary @"${source_file}"
}

# Upload both files to Dropbox
upload_to_dropbox "${sql_file}"
upload_to_dropbox "${zip_file}"

# Clean up temporary files
rm "${sql_file}"
rm "${zip_file}"
