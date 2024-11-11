
#!bin/bash

# Going to root directory
cd /

# List folder in the computer and choose workspace 
ls -l
read -p "Do you want to use an old/ create a new folder ()? (old/ new)" choice1

# Old or new choices logic
if [ "$choice1" = "old" ]; then
    read -p "Enter the name of the old folder: " folder_name
    if [ -d "$folder_name" ]; then
    echo "Folder found. Entering..."
    sleep 3
    cd "$folder_name"
    # Create a project folder
    read -p"Enter the name of a new project folder:" new_project_folder
    mkdir "$new_project_folder"
    echo "Project folder created successfully."
    sleep 3
    cd "$new_project_folder"
    # Initialize the go 
    go mod init "$new_project_folder"
    echo "Go module initialized successfully."
    sleep 3
    # Create main.go file
    touch main.go
    echo "main.go file created successfully."
    sleep 3
    # Creating packages directories
    read -p "Would u like to create packages directories (y/n):: " package_choice
    if [ "$package_choice" = "y" ]; then
    read -p "Enter the name/s spaced of package/s" packages_names
    mkdir -p "${packages_names// / }"
    echo "Packages directories created successfully."
    sleep 3
    # Creatin modules for each package
    
    else
    echo "Folder not found."
        exit 1
    fi
elif [ "$choice1" = "new" ]; then   
    read -p "Enter the name of the new folder which will be your project folder: " folder_name
    mkdir "$folder_name"
    cd "$folder_name"
else
    echo "Invalid choice. Please try again."
    exit 1
fi





