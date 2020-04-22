#!/bin/bash
# Managed on GitHub: https://github.com/firefall-llc/Nano-Default-Editor
#
# default-editor.sh
# This shell script sets nano as the default editor for the system or current user.
# i.e. /usr/local/bin/default-editor.sh -s
#
# @version 0.0.1, 2020-04-22
# @author Scott Park <scott@firefall.com>
# @link http://www.firefall.com/
# @license MIT License
# @copyright Copyright (c) 2020 Firefall, LLC

print_usage() {
	echo 'Usage
	-s Install nano as the default editor for the system
	-u Install nano as the default editor for the current user';
}

# System Default
install_system() {
	
	# Incompatible system
	if ! [ -d /etc/profile.d ]; then
		echo "Error: /etc/profile.d/ doesn't exist. Unsupported system.";
		exit 2;

	# Already installed
	elif [ -f /etc/profile.d/nano.sh ]; then
		echo 'Error: /etc/profile.d/nano.sh already exists.';
		exit 3;
	
	# Install
	else
		echo 'Adding nano as the system default editor to /etc/profile.d/.';
	
		# Source https://wiki.centos.org/EdHeron/EditorDefaultNano
		cat <<EOF >>/etc/profile.d/nano.sh
export VISUAL="nano"
export EDITOR="nano"
EOF
		exit 0;
	fi
}

# User Default
install_user() {
	
	# Incompatible system
	if ! [ -f ~/.bash_profile ]; then
		echo "Error: ~/.bash_profile doesn't exist. Unsupported system.";
		exit 2;

	# Already defined
	elif grep --quiet 'export VISUAL' ~/.bash_profile || grep --quiet 'export EDITOR' ~/.bash_profile; then
		echo 'Error: An editor is already defined in .bash_profile, remove lines containing "export VISUAL=..." and "export EDITOR=..."';
		exit 3;
	
	# Modify .bash_profile
	else
		echo 'Adding nano as the user default editor to the end of ~/.bash_profile';
		
		# Source https://wiki.centos.org/EdHeron/EditorDefaultNano
		cat <<EOF >>~/.bash_profile
export VISUAL="nano"
export EDITOR="nano"
EOF
		exit 0;
	fi
}

# Source: https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash
# Source: https://google.github.io/styleguide/shellguide.html
while getopts 'suh' flag; do
	case "${flag}" in
		s) install_system ;;
		u) install_user ;;
		*) print_usage
		exit 1 ;;
	esac
done

print_usage;
exit 1;
