#!/bin/bash

# Function to decode Base64 encoded string
decode_base64() {
    echo "$1" | tr -d -c 'A-Za-z0-9+/=' | base64 --decode 2>/dev/null
}

# Function to use John the Ripper
use_john_the_ripper() {
    echo "$1" > hash.txt
    john --format=raw-md5 hash.txt
}

# Function to use Hashcat
use_hashcat() {
    echo "$1" > hash.txt
    hashcat -m 0 hash.txt -a 0 /usr/share/john/password.lst
}

# Read the encoded string from the user
read -p "Enter the Base64 encoded string: " encoded_string

# Decode the string
decoded_string=$(decode_base64 "$encoded_string")

# Check if the decoding was successful
if [ -z "$decoded_string" ]; then
    echo "Decoding failed: Invalid Base64 encoded string."
else
    echo "Decoded string: $decoded_string"

    # Ask user which tool to use
    read -p "Choose a tool to crack the hash (john/hashcat): " tool_choice

    if [ "$tool_choice" == "john" ]; then
        use_john_the_ripper "$decoded_string"
    elif [ "$tool_choice" == "hashcat" ]; then
        use_hashcat "$decoded_string"
    else
        echo "Invalid choice. Please choose either 'john' or 'hashcat'."
    fi
fi
