#!/bin/bash
clear
echo "ASO 24/25 Script Assignment"
echo "Student name: Juan Esteban"
echo "Practica assignment management"
echo "------------------------------"

base_dir="$SCRIPT_DIR"

schedule_collection() {

echo -n "Course: "
read curso

echo -n "Path containing student accounts: "
read ORIGIN_PATH

echo -n "Path to store assignments: "
read DESTINATION_PATH

if [ ! -d "$ORIGIN_PATH" ]; then
        echo "Error: The directory $ORIGIN_PATH does not exist."
        write_log "Error directorio no existe"
        exit 1
fi

if [ ! -d "$DESTINATION_PATH" ]; then
    echo "Error: The directory $DESTINATION_PATH does not exist."
    write_log "Error directorio no existe"
    exit 1
fi


collection_time="08:00"

echo "The $COURSE assignment collection process is programmed for $tomorrow at $collection_time ."
echo "Origin: $ORIGIN_PATH. Destination: $DESTINATION_PATH."
echo -n "Do you want to continue? (y/n) "
read CONFIRMATION




if [ $CONFIRMATION == "y" ]; then 

cron_time="* 8 * * *"
cron_entry="$cron_time $base_dir/store-prac.sh $ORIGIN_PATH $DESTINATION_PATH"

(sudo crontab -l 2>/dev/null; echo "$cron_entry") | sudo crontab - 

echo "Cron job added."
write_log "Added cron job for tomorrow at 8:00"

else
        echo "Operation cancelled by user"
        write_log "Operation cancelled by user"
fi
}

pack_course() {
echo -n "Course: "
read curso

echo -n "Absolute path of directory with the assignments: "
read direcion

if [ ! -d "$direcion" ]; then 
        echo "Error: $direcion no existe"
        write_log "Error directorio no existe"  
        exit 1
fi

echo "The assignments of the course $COURSE present in the directory $ASSIGNMENTS_DIR will be packed."
echo -n "Do you want to continue? (y/n) "
    read confirmacion

if [ "$confirmacion" == "y" ]; then 
        fechaa=$(date +%y%m%d)
        nombre_fichero="${direcion}/${curso}-${fechaa}.tgz"
        tar -czvf "$nombre_fichero" -C "${direcion}" .

        if [ $? -ge 0 ]; then 
                echo "The file has been successfully packed: $nombre_fichero_empaquetar"
                write_log "The file was packed $nombre_fichero_empaquetar"      
        else
                echo "Error: there was a problem"
                write_log "Error when creating file"
        fi
else
        echo "USER CANCELL: Operation cancelled by user."
        write_log "Error: Operacion empaquetado cancelada por usuario"
fi

}


backup_info() {

echo -n "Course: "
read curso

fichero_empaquetado=$(find "/home/" -type f -name "${curso}-*.tgz" -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}')

if [ -z "$fichero_empaquetado" ]; then
    echo "Error: No backup file found for the course $COURSE in $BACKUP_DIR."
    write_log "Error non-existen backupfile"
exit 1
fi

FILE_SIZE=$(stat --printf="%s" "$fichero_empaquetado")
FILE_DATE=$(stat --printf="%y" "$fichero_empaquetado")

echo "The file generated is $fichero_empaquetado."
 write_log "Size and date $FILE_SIZE and $FILE_DATE"
echo "Its size is $FILE_SIZE bytes and it was generated on $FILE_DATE."



write_log() {

log_dir=$(cd "$(dirname "$0" )" && pwd)
log_file="${log_dir}/prac.log"

current_date=$(date +'%Y-%m-%d')
current_hour=$(date +'%H:%M')

message=$1

echo "$current_date   $current_hour   $message" >> "$log_file"

}

while true; do

        echo "Menu"
        echo "1) Program collection of assignments solutions"
        echo "2) Pack course assignments"
        echo "3) See size and date of a course backup file"
        echo "4) End program"
        echo -n "Option: "
        read input


        case $input in
                1)
                clear
                echo "Menu 1 - Schedule assignment collection"
                schedule_collection
                ;;
                2)
                clear
                echo "Menu 2 - pack course assignments."
                pack_course
                ;;
                3)
                clear
                echo "Menu 3 - Obtain size and date of backup"
                backup_info
                ;;
                4)
                clear
                echo "Good bye!!"
                exit 0
                ;;
                *)
                echo "insert valid value."
                ;;

        esac

done