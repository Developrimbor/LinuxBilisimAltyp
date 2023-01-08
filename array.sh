#!/bin/bash

host=localhost
user=postgres

inotifywait -m -e create -e delete --format '%e %f' /home/Joseph/Desktop | while read file; do

  now=$(date -Iseconds)

  if [[ $file = *"CREATE"* ]]; then

    psql -h $host -U $user -d $user -c "INSERT INTO array (name, createdtime) VALUES ('$(echo "$file" | cut -d' ' -f2)', '$now');"
  elif [[ $file = *"DELETE"* ]]; then
  
    psql -h $host -U $user -d $user -c "UPDATE array SET deleted=true, deletedtime='$now' WHERE name='$(echo "$file" | cut -d' ' -f2)';"
  fi
done
