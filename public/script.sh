#!/bin/bash

# Go to the root of the computer
cd ~
echo "We are back to the root directory of your computer."

# Ask if the user wants to create a new folder or open an existing one
echo -e "Do you want to: \n1. Create a new folder \n2. Open an existing folder"
sleep 3
read -p "Enter 1 or 2: " choice

if [[ "$choice" == "1" ]]; then
    # Create a new folder
    read -p "Enter the name of the new folder: " folder_name
    mkdir "$folder_name"
    echo "Folder '$folder_name' created."
    cd "$folder_name"
elif [[ "$choice" == "2" ]]; then
    # Open an existing folder
    read -p "Enter the path to the existing folder: " folder_path
    if [[ -d "$folder_path" ]]; then
        cd "$folder_path"
        echo "Changed to existing folder '$folder_path'."
    else
        echo "Folder '$folder_path' does not exist. Exiting."
        exit 1
    fi
else
    echo "Invalid option. Exiting."
    exit 1
fi

# Initialize the Go project
echo "Initializing a new Go project..."
go mod init "$(basename "$PWD")"
echo "Go module initialized."

# Create the main.go file
cat << EOF > main.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
echo "main.go created."

# Ask the user what packages they want to create
read -p "Enter the package names (space-separated): " packages

# Loop over each package and create its directory and file
for package in $packages; do
    # Create the package directory
    mkdir -p "$package"
    
    # Ask for the name of the file to create inside the package
    read -p "Enter the name of the file for package '$package': " file_name
    
    # Create the file inside the package
    cat << EOF > "$package/$file_name.go"
package $package

import "fmt"

// $file_name function that prints the package and filename
func $file_name() {
    fmt.Println("I am $file_name of $package")
}
EOF
    echo "File '$file_name.go' created in package '$package'."
done

# Update main.go to call the functions from each created package
for package in $packages; do
    # Ask for the file names in each package and add import statements in main.go
    read -p "Enter the function name to call from package '$package': " func_name
    sed -i "/import (/{n;s|)|\t\"./$package\"|\n\t\"./$package\"|}" main.go
    sed -i "/func main()/a \\n\t$package.$func_name()" main.go
done
echo "main.go updated with package imports and function calls."

# Create and configure .gitignore, Makefile, and README.md
echo "Creating basic configuration files..."

# .gitignore setup
echo "/bin/" > .gitignore
echo "/vendor/" >> .gitignore
echo "Initial .gitignore created."

# README.md setup
cat << EOF > README.md
# $(basename "$PWD")
This is a Go project created with a custom Bash script.

## Project Setup
1. Clone the repository
2. Run `go run main.go` to see the output
EOF
echo "README.md created."

# Makefile setup
cat << EOF > Makefile
build:
    go build -o bin/$(basename "$PWD") main.go

run:
    go run main.go

clean:
    rm -rf bin/
EOF
echo "Makefile created."

# Git operations
echo "Initializing Git repository..."
git init
git add .
git commit -m "feature: Project engine starts"
echo "Git repository initialized, files added, and initial commit made."

# Done
echo "Project setup is complete!"
