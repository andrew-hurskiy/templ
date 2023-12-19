#!/bin/bash
# Empy arrays
environments=()
services=()

# Read each line from the file and add it to the array
while IFS= read -r line; do
    environments+=("$line")
done < ./envs

# Loop through subdirectories of the "service" directory
for dir in services/*; do
    # Check if the current item is a directory
    if [ -d "$dir" ]; then
        # Add the directory name to the array
        services+=("$(basename "$dir")")
    fi
done

# Print the contents of the array
echo "Services are: ${services[@]}"

# Iterate over the environments and print them
for env in "${environments[@]}"; do
	for service in "${services[@]}"; do
		./xml_generator.sh \
			"$env" \
		       	"services/$service/template.xml" \
			"services/$service/vars" \
		       	"configs/${service}-${env}.xml"
	done
done
