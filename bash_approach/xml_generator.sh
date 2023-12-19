#!/bin/bash
validate(){
	env_name="$1"
	template_file="$2"
	data_file="$3"
	result_file="$4"
	
	# Make sure exactly 4 params are provided
	if [ $# -ne 4 ]; then
	    echo "Usage: $0 env_name template_file env_file result_file"
	    exit 1
	fi

	if [ ! -n "$env_name" ]; then
	    echo "Environment is not provided"
	    exit 1
	fi

	if [ ! -f "$template_file" ]; then
	    echo "Template file not found: $template_file"
	    exit 1
	fi

	if [ ! -f "$data_file" ]; then
	    echo "Data file not found: $data_file"
	    exit 1
	fi
}

backup_template(){
	# Keep original version of template,
	# sine it will be overwritten
	# during sed operation of text replacement
	template_file_bak="${tmplate_file}.bak"
	cp "$template_file" "$template_file_bak"
}


replace_placeholders_with_data(){
	# Here we treat special env variable substitution
	env_var_name="ENV"
	sed -i "s|{{\s*$env_var_name\s*}}|$env_name|g" "$template_file"

	while IFS= read -r line; do
	    # Split each line into variable name and value
	    var_name="${line%%=*}"
	    var_value="${line#*=}"

	    sed -i "s|{{\s*$var_name\s*}}|$var_value|g" "$template_file"
	done < "$data_file"

	# Copy the modified template to the result file
	cp "$template_file" "$result_file"
}

restore_template(){
	# Revert template to original one
	rm "$template_file"
	mv "$template_file_bak" "$template_file"
}

# Run
validate $1 $2 $3 $4
backup_template
replace_placeholders_with_data
restore_template
