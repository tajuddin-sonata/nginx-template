#!/bin/bash
echo "This is my sample shell script"
echo "My shell script name is $0"
echo "My hostname is: $(hostname)"
echo "Print disk space"
df -h
echo "create a directory"


directory="/opt/directory1"

if [ -d "$directory" ]; then
    echo "Directory $directory already exists. Removing it..."
    rm -rf "$directory"
fi

echo "Creating directory $directory"
mkdir -p "$directory"