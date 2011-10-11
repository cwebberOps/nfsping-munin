#!/usr/bin/env ruby

# Usage:
# nfsping_<nfs server> -> nfsping.rb
#
# Synopsis:
# The nfs server is determined by the name after the dash in the symlink. That is 
# used to do a 10 count nfsping which is parsed, returning the average, max and min
# values for munin to graph.

require 'socket'

# Add methods to Enumerable, which makes them available to Array
module Enumerable
 
	#  sum of an array of numbers
	def sum
		return self.inject(0){|acc,i|acc +i}
	end
 
	#  average of an array of numbers
	def average
		return self.sum/self.length.to_f
	end
 
end  #  module Enumerable

# Name of the script
MY_NAME = File.basename(__FILE__)

### The constants set below should probably end up in a config file somewhere

# Number of tries to pass to nfsping
NUM_TRIES = 10

# Location of the nfsping binary
NFSPING = '/home/cwebber/src/NFSping/src/nfsping' 

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

# Check for nfsping existing and being executable
unless File.exist?(NFSPING) && File.executable?(NFSPING)
	puts "ERROR: #{NFSPING} does not exist or is not executable"
	exit -1
end

# Run nfsping and collect the results
output = `#{NFSPING} -C #{NUM_TRIES} -q #{nfs_server} 2>&1`
if $? != 0
	exit 0
end

# Take the output and generate an array with all of the numbers converted to
# float.
values = []
output.split(':')[1].strip.split().each do |value|
	values << value.to_f
end

puts "min.value #{values.min}"
puts "max.value #{values.max}"
puts "avg.value #{values.average}"

