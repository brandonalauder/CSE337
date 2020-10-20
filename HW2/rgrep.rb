args = ARGV
fileName, *options, pattern = ARGV
count=nil
options << '-p' if (options&['-p', '-w', '-v']).length == 0

options.each do |option|
  if fileName !~ /\.txt/
    puts 'Missing Required Arguments'
    break
  end
  if pattern =~ /\A-/ || pattern.nil?
    puts 'Missing Required Arguments'
    break
  end
  if (options&['-p', '-w', '-v']).length >1
    puts 'Invalid combination of options'
    break
  end
  if (options&['-c', '-m']).length > 1
    puts 'Invalid combination of options'
    break
  end

  case option
  when '-w'
    File.open(fileName, "r") do |aFile|
      if options.include? '-c'
        count=0
        aFile.each_line { |line| count+=1 if line=~/\b#{pattern}\b/}
        puts count
      elsif options.include? '-m'
        aFile.each_line { |line| puts $& if line=~/\b#{pattern}\b/}
      else
        aFile.each_line { |line| puts line if line=~/\b#{pattern}\b/}
      end
    end
  when '-p'
    re=Regexp.new(pattern)
    File.open(fileName, "r") do |aFile|
      if options.include? '-c'
        count=0
        aFile.each_line { |line| count+=1 if line =~ re }
        puts count
      elsif options.include? '-m'
        aFile.each_line { |line| puts $& if line =~ re }
      else
        aFile.each_line { |line| puts line if line =~ re }
      end
    end
  when '-v'
    if options.include? '-m'
      puts 'Invalid combination of options'
      break
    end
    re=Regexp.new(pattern)
    File.open(fileName, "r") do |aFile|
      if options.include? '-c'
        count=0
        aFile.each_line { |line| count+=1 if line !~ re }
        puts count
      else
        aFile.each_line { |line| puts line if line !~ re }
      end
    end
  when '-c'
    if (options&['-p', '-w', '-v']).any?
      next
    else
      puts 'Invalid combination of options'
      break
    end
  when '-m'
    if (options&['-p', '-w']).any?
      next
    else
      puts 'Invalid combination of options'
      break
    end
  else
    puts 'Invalid option'
  end
end
