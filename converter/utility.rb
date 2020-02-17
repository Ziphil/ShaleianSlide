# coding: utf-8


class String

  def indent(size)
    inside_code = false
    split_self = self.each_line.map do |line|
      if inside_code 
        if line =~ /^\s*<\/pre>/
          inside_code = false
        end
        next line
      else
        if line =~ /^\s*<pre>/
          inside_code = true
        end
        next " " * size + line
      end
    end
    return split_self.join
  end

  def deindent
    margin = self.scan(/^ +/).map(&:size).min
    return self.gsub(/^ {#{margin}}/, "")
  end

  def deindent!
    margin = self.scan(/^ +/).map(&:size).min
    self.gsub!(/^ {#{margin}}/, "")
  end

end