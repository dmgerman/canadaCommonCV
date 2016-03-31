#!/bin/ruby

# This program extracts the list of references from a Common CV in NSERC format (text format, converted from pdf)

file=ARGV[0]

state = '';

jp = Array.new
cp = Array.new

File.readlines(file).each do |line|
  if line =~ /^Journal Articles$/
    state = 'J';
    next;
  elsif line =~ /^Conference Publications$/
    state = 'C';
    next;
  end
  if state == 'C'
    cp << line
  elsif state == 'J'
    jp << line
  end
end

def split(lines, type)
  papers = lines.join('').gsub(/^([0-9]+)\.\n/, 'JP\1;').gsub(/\n/,' ').gsub(/JP/,"\nJP").gsub(/^JP([0-9]+)\;[^)]+\)\./,'JP\1;')
  papers.gsub(/\..+$/,'.').gsub(/^JP(\d+;) */,(type.+'\1')).gsub(/^\n/,'').+("\n")
end

cpapers = split(cp, 'C') 
jpapers = split(jp, 'J')

print cpapers
print jpapers



#if id2 = (/^(?<id>[0-9]+)\.$/.match(line)) and (state == 'J' or state == 'C')
#  id = id2[1]
#  print "#{state} #{id}:\n"
#end
