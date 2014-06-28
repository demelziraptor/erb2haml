require 'find'

RED_FG ="\033[31m"
GREEN_FG = "\033[32m"
END_TEXT_STYLE = "\033[0m"

# Helper method to inject ASCII escape sequences for colorized output
def color(text, begin_text_style)
  begin_text_style + text + END_TEXT_STYLE
end

# Check for dependency
def check_for_html2haml
  if `which html2haml`.empty?
    puts "#{color "ERROR: ", RED_FG} Could not find " +
         "#{color "html2haml", GREEN_FG} in your PATH. Aborting."
    exit(false) 
  end
end

# Perform file operations
class ERBFile
  def initialize(path)
    @erb_path = path
    @haml_path = path.slice(0...-3)+"haml"
  end
  
  def path
    @erb_path
  end
  
  def haml_exists?
    FileTest.exists?(@haml_path)
  end
  
  def convert_erb
    system("html2haml", @erb_path, @haml_path)
  end
  
  def remove_erb
    system("rm", @erb_path)
  end
end

# Control screen messages and counters and file operations
class Overlord
  def initialize(path, config, counter)
    @file = ERBFile.new(path)
    @counter = counter
    @config = config
    
    @counter.counts[:total] += 1
  end
  
  def haml_exists?
    if @file.haml_exists?
      @counter.counts[:skips] += 1
      puts "HAML already exists, skipping: #{@file.path}...#{color("done", GREEN_FG)}" if @config['verbose']
      true
    end
  end
  
  def convert_erb
    if self.haml_exists?
      return true
    end
    print "Converting: #{@file.path}... " if @config['verbose']
    
    if @config['dryrun']
      @counter.counts[:converts] += 1
      puts color("No change!", GREEN_FG) if @config['verbose']
      return true
    end
    if @file.convert_erb
      @counter.counts[:converts] += 1
      puts color("Done!", GREEN_FG) if @config['verbose']
      return true
    end
    @counter.counts[:convert_errors] += 1
    puts color("Failed!", RED_FG) if @config['verbose']
    false
  end
  
  def remove_erb
    if @config['replace']
      print "Removing: #{@file.path}... " if @config['verbose']
      
      if @config['dryrun']
        @counter.counts[:removes] += 1
        puts color("No change!", GREEN_FG) if @config['verbose']
        return true
      end
      if @file.remove_erb
        @counter.counts[:removes] += 1
        puts color("Removed!", GREEN_FG) if @config['verbose']
        return true
      end
      @counter.counts[:remove_errors] += 1
      puts color("Failed!", RED_FG) if @config['verbose']
      false
    end
  end
end
      
# Keep track of counts
class ActionCounter
  attr_accessor :counts
  
  def initialize
    @counts = {total: 0, skips: 0, converts: 0, removes: 0, convert_errors: 0, remove_errors: 0}
  end
  
  def are_errors?
    return false if (@counts[:convert_errors] == 0 and @counts[:remove_errors] == 0)
    true
  end 

  def print(replace)
    text = "Total erb files: #{@counts[:total].to_s}, files converted: #{@counts[:converts].to_s}, files skipped: #{@counts[:skips].to_s}"
    text += ", files removed: #{@counts[:removes].to_s}" if replace
    text += "\nConversion errors: #{@counts[:convert_errors].to_s}, removal errors: #{@counts[:remove_errors].to_s}" if self.are_errors?
    text += "\n"
  end
end

# Perform search (and replace)
def convert(config)
  check_for_html2haml
  counter = ActionCounter.new
  
  puts "Looking for #{color "ERB", GREEN_FG} files to convert to " +
      "#{color("Haml", RED_FG)}..."
      
  Find.find("app/views/") do |path|
  
    if FileTest.file?(path) and path.downcase.match(/\.erb$/i)
      overlord = Overlord.new(path, config, counter)
      overlord.remove_erb if overlord.convert_erb
    end
  end
  
  print "==== Result ====\n"
  print counter.print(config['replace'])
end



namespace :haml do
  desc "Perform bulk conversion of all html.erb files to Haml in views folder.  "\
       "Optional arguments: "\
         "replace (to delete converted erb files), "\
         "verbose (to see actions for each file),  "\
         "dryrun (do not make any changes).  "
       "eg: rake haml:convert replace."
       
  task :convert do
    passed_args = ARGV[1..-1]
    passed_args.each do |arg|
      task arg.to_sym do ; end 
    end 
    
    possible_args = ['replace', 'verbose', 'dryrun']
    selected_args = passed_args & possible_args
    
    print "Running conversion with following options: #{selected_args.join(", ")}\n"
    
    args = Hash[possible_args.map { |a| [a, false] }]
    
    possible_args.each do |arg|
      args[arg] = true if selected_args.include? arg
    end
    
    convert(args)
    
  end
end
