# coding: utf-8


class Tag

  def apply_count(element, count)
    range_string = element.attribute("range").to_s
    if match = range_string.match(/(\d*)-(\d*)/)
      begin_count = (match[1].empty?) ? nil : match[1].to_i - 1
      end_count = (match[2].empty?) ? nil : match[2].to_i - 1
      range = Range.new(begin_count, end_count)
      unless range.cover?(count)
        self["style"] ||= ""
        self["style"] << "visibility: hidden;"
      end
    end
  end

end