#!/bin/bash

# Go to the root of the computer
cd ~
echo "We are back to the root directory of your computer."

# Ask the user if they want to create a new folder or open an existing one
echo -e "Do you want to: \n1. Create a new folder \n2. Open an existing folder"
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

# Create a new Go project
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

# Ask the user if they want to create additional packages and directories
read -p "Do you want to create additional packages and directories? (yes/no): " create_packages

if [[ "$create_packages" == "yes" ]]; then
    read -p "Enter the package names (space-separated): " packages
    for package in $packages; do
        mkdir -p "$package"
        cat << EOF > "$package/$package.go"
package $package

// $package.go - basic structure of the $package package
func Example() {
    // Example function in $package package
}
EOF
        echo "Package '$package' created with $package.go."
    done
fi

# Display message confirming that the project structure is complete
echo "Project structure created successfully."

# Import the packages into main.go (append imports if packages were created)
if [[ "$create_packages" == "yes" ]]; then
    echo "Modifying main.go to include package imports..."
    for package in $packages; do
        sed -i "s|\"fmt\"|\"fmt\"\n\t\"./$package\"|" main.go
    done
    echo "main.go updated with package imports."
fi

echo "Go project setup is complete!"
