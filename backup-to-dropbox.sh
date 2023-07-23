#!/bin/bash
# Php Ninja Website Backup & upload to dropbox
# developers@phpninja.es
#
# Description
# This script will do a zip of the target folder and dump the MySQL database with mysqldump, then will upload both files to Dropbox
# License: GPL-3

# MySQL Credentials
db_user="DB USER"
db_password="DB PASSW"
db_name="DB NAME"
db_host="DB HOST"
db_port="3306"

# Dropbox API Access Token
dropbox_token="YOUR DROPBOX TOKEN"

# Dropbox Folder Structure: hostname/date/file1.zip
hostname="THIS IS THE NAME OF THE FUTURE FOLDER IN DROPBOX"

# Folder to zip and extract
www_folder="www"

# Defaults
backup_date=$(date +%Y-%m-%d)
zip_file="files_${hostname}_${backup_date}.zip"
sql_file="database_${hostname}_${backup_date}.sql"
sql_zip_file="database_${hostname}_${backup_date}.zip"

# Upload both files to Dropbox
upload_to_dropbox() {
    local source_file="$1"
    # Folder Structure: hostname/date/file1.zip
    local dropbox_path="/${hostname}/${backup_date}/${source_file}"
    local dropbox_api_url="https://content.dropboxapi.com/2/files/upload"
    echo "${dropbox_path}"
    curl -X POST "${dropbox_api_url}" \
  	 --header "Authorization: Bearer ${dropbox_token}" \
         --header "Content-Type: application/octet-stream" \
         --header "Dropbox-API-Arg: {\"path\":\"${dropbox_path}\", \"mode\":\"add\"}" \
         --data-binary @"${source_file}"         
}

echo "========================"
echo "BACKUP OF ${hostname}"
echo "Date: ${backup_date} - Folder: ${www_folder}"
echo "Base files: ${zip_file} & ${sql_file}"
echo "========================"

# Backup MySQL Database
echo "Starting DATABASE BACKUP...."
mysqldump -h "${db_host}" -P "${db_port}" -u "${db_user}" -p"${db_password}" "${db_name}" --no-tablespaces > "${sql_file}"

echo "Zipping SQL file..."
zip -s 100M "${sql_zip_file}" "${sql_file}"
echo "Cleaning SQL file ..."
rm "${sql_file}"

echo "Uploading DATABASE to DROPBOX..."

for zip_chunk in "database_${hostname}_${backup_date}"*; do
	echo "Uploading a database zip chunk to dropbox"
    	upload_to_dropbox "${zip_chunk}"
   	rm "${zip_chunk}"
done


# ZIP
echo "========================"
echo "Files Backup Zipping ... "
zip -r -s 100M "${zip_file}" "${www_folder}" -x "cache/*" "tmp/*" ".git/*" "git/*" "ninja/*"

# Upload zip chunks
echo "Uploading ZIP chunks to DROPBOX..."
for zip_chunk in "files_${hostname}_${backup_date}"*; do
	echo "Uploading zip chunk to Dropbox ..."
    	upload_to_dropbox "${zip_chunk}"
    	# Clean up temporary files
	echo "Cleaning ... "
   	rm "${zip_chunk}"
done


echo "Completed ------"
