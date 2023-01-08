#!/bin/bash

DB_HOST=localhost
DB_USER=postgres
DB_NAME=postgres

psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "CREATE TABLE IF NOT EXISTS dizi (name text, createdtime timestamptz, deleted boolean DEFAULT false, deletedtime timestamptz);"

inotifywait -m -e create -e delete --format '%e %f' /home/Joseph/Desktop | while read file; do

  now=$(date -Iseconds)

  if [[ $file = *"CREATE"* ]]; then

    psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "INSERT INTO array (name, createdtime) VALUES ('$(echo "$file" | cut -d' ' -f2)', '$now');"
  elif [[ $file = *"DELETE"* ]]; then
  
    psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "UPDATE array SET deleted=true, deletedtime='$now' WHERE name='$(echo "$file" | cut -d' ' -f2)';"
  fi
done
