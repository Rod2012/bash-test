#!/bin/bash

#!/usr/bin/env bash
# config.sh

# remove the part where the script asks for user input at the beginning of the script, so that script relies only on config.txt file for parameters

# make it so the script looks for changes in the config.txt before switching from API 1 to API2, and when it switches from API2 to API3



# mkdir automata
# root@dk-rsalcedo:/opt# chown root:rsalcedo -R  automata/
# root@dk-rsalcedo:/opt# chmod 775 -R automata/

config_file="config.txt"

source "$config_file"

# Check if the configuration file exists
if [ -f "$config_file" ]; then
    # Configuration file exists, source it
else
    echo "The config file was not found on $(pwd)"
    
fi

# main.sh

# Source the configuration file
# source config.sh
start_command="/usr/local/bin/myria-node --start"
stop_command="/usr/local/bin/myria-node --stop"

# Function to send a notification with input text
send_notification() {
    local notification_text="$1"
    if [ -n "$bot_token" ] && [ -n "$chat_id" ]; then
        # Assuming you construct the telegram_url using bot_token
        telegram_url="https://api.telegram.org/bot$bot_token/sendMessage"
        curl -s -X POST "$telegram_url" -d chat_id="$chat_id" -d text="$notification_text"
    else
        echo "Bot token or chat_id is not set. Skipping notification."
    fi
}



#Function to start the service with input text
start_service() {
    local input_text="$1"
    echo "$input_text" | $start_command

    # Check if the service started successfully
    if [ $? -eq 0 ]; then
        echo "Service started successfully"
        send_notification "Service started successfully"
    else
        echo "Failed to start service"
        send_notification "Failed to start service"
        exit 1
    fi
}

# Function to stop the service with input text
stop_service() {
    local input_text="$1"
    echo "$input_text" | $stop_command

    # Check if the service stopped successfully
    if [ $? -eq 0 ]; then
        echo "Service stopped successfully"
        send_notification "Service stopped successfully"
    else
        echo "Failed to stop service"
        send_notification "Failed to stop service"
    fi
}

counter=0

while true; do
    # Get the current time in 24-hour format
    current_time=$(date +%H:%M)

    # Calculate the time difference in minutes
    desired_minutes=$(date -d "$start_time" +%s)
    current_minutes=$(date -d "$current_time" +%s)

    time_difference=$((desired_minutes - current_minutes))

    # Check if the desired time is in the future
    if [ $time_difference -gt 0 ]; then
        echo "Waiting until $start_time to run the command..."
        sleep $time_difference
    else
        echo "Executing your command at $start_time"

        if [ -n "$input_text1" ]; then
            ((counter++))
            echo "The value of API is: $input_text1"
            start_service "$input_text1"

            # Check if bot_token is set before using curl for Telegram
            if [ -n "$bot_token" ]; then
                output=$(/usr/local/bin/myria-node --status)
                # Format the output for sending via Telegram
                message=$(echo -e "Command output:\n$output")
                echo "$message"
                if [ -n "$chat_id" ]; then
                    send_notification "$message"
                else
                    echo "Telegram chat_id is not set. Skipping notification."
                fi
            else
                echo "Telegram bot_token is not set. Skipping notification."
            fi

            sleep $work_duration
            stop_service "$input_text1"
        else
            echo "Variable1 does not exist."
        fi

        # read again
        source "$config_file"
        if [ -n "$input_text2" ]; then 
            ((counter++))
            echo "The value of API is: $input_text2"
            start_service "$input_text2"

            # Check if bot_token is set before using curl for Telegram
            if [ -n "$bot_token" ]; then
                output=$(/usr/local/bin/myria-node --status)
                # Format the output for sending via Telegram
                message=$(echo -e "Command output:\n$output")
                echo "$message"
                if [ -n "$chat_id" ]; then
                    send_notification "$message"
                else
                    echo "Telegram chat_id is not set. Skipping notification."
                fi
            else
                echo "Telegram bot_token is not set. Skipping notification."
            fi

            sleep $work_duration
            stop_service "$input_text2"
        else
            echo "Variable2 does not exist."
        fi

        # read again
        source "$config_file"
        if [ -n "$input_text3" ]; then
            ((counter++))
            echo "The value of API is: $input_text3"
            start_service "$input_text3"

            # Check if bot_token is set before using curl for Telegram
            if [ -n "$bot_token" ]; then
                output=$(/usr/local/bin/myria-node --status)
                # Format the output for sending via Telegram
                message=$(echo -e "Command output:\n$output")
                echo "$message"
                if [ -n "$chat_id" ]; then
                    send_notification "$message"
                else
                    echo "Telegram chat_id is not set. Skipping notification."
                fi
            else
                echo "Telegram bot_token is not set. Skipping notification."
            fi

            sleep $work_duration
            stop_service "$input_text3"
        else
            echo "Variable3 does not exist."
        fi

        # Exit the script after running the commands
        exit 0
    fi
done