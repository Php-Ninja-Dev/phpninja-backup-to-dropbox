# Php Ninja Backup & Dropbox

Php Ninja Backup & Dropbox is a powerful tool that allows you to create backups of your PHP applications and effortlessly store them in your Dropbox account. With this script, you can ensure the safety of your valuable data and have peace of mind knowing that your critical files are securely backed up in the cloud.

Bash, shell script to be executed from the target server. It will compile files and DB and then upload them to your Dropbox.

## Features
- **Easy Configuration**: Simple setup process with easy-to-understand instructions.
- **Automated Backup**: Schedule the script to run as a cron job for automated, periodic backups.
- **Secure Storage**: Your backups are securely stored in your Dropbox account, ensuring data integrity and confidentiality.
- **Customizable**: Easily modify the database credentials and target folder to suit your specific needs.

### To-do
- **Notifications (Optional)**: Optionally, receive notifications when the backup process is completed successfully.

## Installation

1. Clone the repository to your target host:

```bash
git clone https://github.com/your-username/your-repo.git
```
Or just download the .sh file and upload it to the target server

2. The script should be in the parent folder of the folder you want to backup (~www,httpdocs,etc...)

```bash
cd /[the parent directory of the folder you want to backup and have the website files.]
```

3. Modify the database credentials and target folder in the `backup-to-dropbox.sh` script:

```bash
# Replace the following placeholders with your actual database credentials
DB_USER="your_database_user"
DB_PASS="your_database_password"
DB_NAME="your_database_name"
DB_HOST=""
DB_PORT=""

# Dropbox API Access Token
dropbox_token=""
hostname="hostname will be used as root folder in Dropbox"

# Set the target folder path in your Dropbox
www_folder=" Here is the name of the folder that contains the website "
```

4. Make the script executable:

```bash
chmod +x backup-to-dropbox.sh
```

## Usage

Run the backup script manually:

```bash
./backup-to-dropbox.sh
```

### Automated Backups

To schedule automated backups, set up a cron job on your system. Open your crontab configuration:

```bash
crontab -e
```

Add the following line to run the backup script daily at 1:00 AM (adjust the timing as needed):

```bash
0 1 * * * /path/to/your-repo/backup-to-dropbox.sh
```

Save and exit the crontab editor.

## Troubleshooting

If you encounter any issues or have questions, feel free to [open an issue](link-to-issues) on the repository.

**Note:** We highly recommend setting up notifications to receive alerts when the backup process encounters errors.

## Contributions

We welcome contributions to enhance Php Ninja Backup & Dropbox. If you have any suggestions or improvements, feel free to fork the repository and submit a pull request.

## License

Php Ninja Backup & Dropbox is licensed under the [MIT License](link-to-license). Feel free to use, modify, and distribute the code as per the terms specified in the license.

---
