# Script to backup database file db/notification_emails.sqlite3
# Uses file db/backup_timestamp to detect changes since last backup 
# Requires uuencode / Mail

# 1. Configure the backup title (used for email subject) and the BACKUP_EMAIL (email address)
BACKUP_TITLE='mynewwebapp db backup'
BACKUP_EMAIL=testing@mailinator.com

# 2. Add to crontab
# crontab -e
# */10 * * * * bash /ABSOLUTE_PATH_TO_THIS_SCRIPT/backup_db.sh

# 3. Rest should be fine

FILE_PATH=`dirname "$0"`
DB_FILE=$FILE_PATH/../db/notification_emails.sqlite3
TIMESTAMP_FILE=$FILE_PATH/../db/backup_timestamp

if  [ ! -f "$DB_FILE" ]; then
  # Nothing to backup
  exit 0
fi

if  [ ! -f "$TIMESTAMP_FILE" ] || [ "$DB_FILE" -nt "$TIMESTAMP_FILE" ]
then
   TSTAMP1=`date +%Y-%m-%d-%H-%M-%S`
   TSTAMP2=`date +%Y-%m-%d\ %H:%M:%S`
   touch $TIMESTAMP_FILE
   uuencode  $DB_FILE $TSTAMP1.sqlite3 | Mail -s "$BACKUP_TITLE at $TSTAMP2" $BACKUP_EMAIL
fi
