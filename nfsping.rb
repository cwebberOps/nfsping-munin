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

# Number of tries to pass to nfsping
NUM_TRIES = 10

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

# Output the basic config details
if ARGV[0] == 'config'
	puts "graph_title #{nfs_server} - NFS Latency"
	puts "graph_vlabel ms"
	puts "graph_category nfs"
	puts "avg.label avg"
	puts "min.label min"
	puts "max.label max"

	puts "graph_info NFS latency using the nfsping utility"
	puts "avg.info Average over #{NUM_TRIES} tries"
	puts "min.info Minimum over #{NUM_TRIES} tries"
	puts "max.info Maximum over #{NUM_TRIES} tries"
	exit 0
end

