#!/usr/bin/env ruby

# Usage:
# nfsping_<nfs server> -> nfsping.rb
#
# Synopsis:
# The nfs server is determined by the name after the dash in the symlink. That is 
# used to do a 10 count nfsping which is parsed, returning the average, max and min
# values for munin to graph.

require 'socket'

# Name of the script
MY_NAME = File.basename(__FILE__)

# Output the basic config details


# Check to see if the nfs server is specified, otherwise exit.
if MY_NAME =~ /_/
	nfs_server = MY_NAME.split('_')[1]
else
	puts "ERROR: No server specified."
	exit -1
end

# Check to see if we can resolve the server or exit
begin
	Socket.gethostbyname(nfs_server)
rescue
	puts "ERROR: NFS server cannot be resolved"
	exit -1
end
