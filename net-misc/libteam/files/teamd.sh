# Copyright (c) 2012 Andrei Vinogradov <andreis.vinogradovs@gmail.com>
# Released under the 2-clause BSD license.

team_depend() {
	programm /usr/bin/teamd
	after interface
	prowide team 
}

_is_team() {
	
}

team_pre_start() {
	# Interface to called team
# if /sys/devices/virtual/net/team*
	#Create team
}

team_start() {
	#create
	# ip link add teamN mode team
}


