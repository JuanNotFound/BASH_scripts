This is a simple script that runs a series of links from a file. It helps me every morning to open multiple elements at 7:00 AM by using a cron job. 

crontab -e // To edit the cron job files on macOS.
chmod +x mail.sh //Executable permision for the script.
0 7 * * * /PATH/TO/Script/mail.sh links.txt //Cron job to run a script at 7:00 AM each morning. 