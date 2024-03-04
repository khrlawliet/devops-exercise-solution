deploy_package_path="deployPackage"
added_path="$deploy_package_path/added"
removed_path="$deploy_package_path/removed"
added_files=""
removed_files=""

mkdir -p $added_path
mkdir -p $removed_path

while IFS= read -r line || [[ -n $line ]]; do

    #extract column 1 on line
    status=$(echo "$line" | awk '{print $1}')
    #extract column 2 on line and remove carriage return character
    filepath=$(echo "$line" | awk '{print $2}' | tr -d '\r')

    #extract filename from filepath
    filename=$(basename "$filepath")

    if [[ "$status" == "M" || "$status" == "A" ]]; then
        added_files+="$filename\n"
        cp "$filepath" "$added_path"
    elif [[ "$status" == "R" || "$status" == "D" ]]; then
        removed_files+="$filename\n"
        cp "$filepath" "$removed_path"
    fi

done <file_diff.txt

echo -e "$added_files" >"added.txt"
echo -e "$removed_files" >"removed.txt"
