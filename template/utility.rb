# coding: utf-8


class Tag

  def self.repeat(element, &block)
    end_counts = element.each_xpath("descendant::node()[@range]").map do |child|
      range = Range.from(child.attribute("range").to_s)
      end_count = range.end || range.begin
      next end_count
    end
    repeat = end_counts.max || 1
    repeat.times do |count|
      block.call(count)
    end
  end

  def set_range(element, count)
    range = Range.from(element.attribute("range").to_s)
    if range && !range.cover?(count + 1)
      self["style"] ||= ""
      self["style"] << "visibility: hidden;"
    end
  end

end


class Range

  def self.from(string)
    range = nil
    if match = string.match(/(\d*)-(\d*)/)
      begin_count = (match[1].empty?) ? nil : match[1].to_i
      end_count = (match[2].empty?) ? nil : match[2].to_i
      range = Range.new(begin_count, end_count)
    end
    return range
  end

end