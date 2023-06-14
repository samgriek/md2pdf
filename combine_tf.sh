#!/bin/bash

# Check if the correct number of arguments were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <output_file>"
    exit 1
fi

# Get the directory and output file from the command line arguments
directory=$1
output_file=$2

# Make sure the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory $directory does not exist"
    exit 1
fi

# Initialize or overwrite the output file
echo "" > $output_file

# Loop through all .tf files in the directory
for file in $directory/*.tf
do
    # Concatenate the file to the output file
    echo "# Start of $file" >> $output_file
    cat $file >> $output_file
    echo "# End of $file" >> $output_file
    echo "" >> $output_file
done

echo "All .tf files in $directory have been concatenated into $output_file"
