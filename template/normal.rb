# coding: utf-8


COLORS = {1 => "blue", 2 => "orange", 3 => "pink", 4 => "green"}

converter.add(["slide"], ["root"]) do |element, _, number|
  this = ""
  slide_number = element.attribute("number").to_s.to_i
  Tag.repeat(element) do |count|
    variables[:slide_count] = variables[:slide_count].to_i + 1
    this << Tag.build("div", "slide") do |this|
      this << Tag.build("div", "number") do |this|
        this << Tag.build("span", "section") do |this|
          this << number.to_s
        end
        this << Tag.build("span", "subsection") do |this|
          this << slide_number.to_s
        end
      end
      this << Tag.new("div", "header")
      this << Tag.new("div", "footer")
      this << Tag.build("div", "content") do |this|
        this << apply(element, "slide", count)
      end
    end
  end
  next this
end

converter.add(["xl"], ["slide"]) do |element, _, count|
  this = ""
  this << Tag.build("ul", "conlang") do |this|
    this.set_range(element, count)
    this << apply(element, "slide.xl", count)
  end
  next this
end

converter.add(["li"], ["slide.xl"]) do |element, _, count|
  this = ""
  this << Tag.build("li") do |this|
    this.set_range(element, count)
    this << apply(element, "slide.xl.li", count)
  end
  next this
end

converter.add(["sh"], ["slide.xl.li"]) do |element, _, count|
  this = ""
  this << apply(element, "slide", count)
  next this
end

converter.add(["ja"], ["slide.xl.li"]) do |element, _, count|
  this = ""
  this << Tag.build("ul") do |this|
    this.set_range(element, count)
    this << Tag.build("li") do |this|
      this << apply(element, "slide", count)
    end
  end
  next this
end

converter.add(["table"], ["slide"]) do |element, _, count|
  this = ""
  this << Tag.build("table") do |this|
    if element.attribute("border")
      this["class"] = "border"
    elsif element.attribute("plain")
      this["class"] = "plain"
    end
    this.set_range(element, count)
    this << apply(element, "slide.table", count)
  end
  next this
end

converter.add(["tr"], ["slide.table"]) do |element, _, count|
  this = ""
  this << Tag.build("tr") do |this|
    this.set_range(element, count)
    this << apply(element, "slide.table.tr", count)
  end
  next this
end

converter.add(["th", "td"], ["slide.table.tr"]) do |element, _, count|
  this = ""
  this << Tag.build do |this|
    case element.name
    when "th"
      this.name = "th"
    when "td"
      this.name = "td"
    end
    if element.attribute("row")
      this["rowspan"] = element.attribute("row").to_s
    end
    if element.attribute("col")
      this["colspan"] = element.attribute("col").to_s
    end
    if align = element.attribute("a")
      case align.to_s
      when "l"
        this["class"] = this["class"].to_s + " left"
      when "r"
        this["class"] = this["class"].to_s + " right"
      when "c"
        this["class"] = this["class"].to_s + " center"
      end
    end
    this.set_range(element, count)
    this << apply(element, "slide", count)
  end
  next this
end

converter.add(["pl", "bpl", "upl"], ["slide"]) do |element, _, count|
  this = ""
  color_index = element.attribute("c").to_s.to_i
  color = COLORS[color_index]
  this << Tag.build("span", "pile") do |this|
    this.set_range(element, count)
    if element.any?{|s| s.is_a?(Element) && s.name == "a"}
      this << Tag.build("span", "above") do |this|
        this["class"] << " #{color}" if color
        this << apply(element.get_elements("a").first, "slide", count)
      end
    end
    this << Tag.build("span", "below-wrapper") do |this|
      if element.any?{|s| s.is_a?(Element) && s.name == "c"}
        this << Tag.build("span", "center") do |this|
          unless element.name == "pl"
            this << Tag.build("span", "box") do |this|
              case element.name
              when "bpl"
                this["class"] = "box"
                this["class"] << " #{color}"
              when "upl"
                this["class"] = "underline"
              end
              this << apply(element.get_elements("c").first, "slide", count)
            end
          else
            this << apply(element.get_elements("c").first, "slide", count)
          end
        end
      end
      if element.any?{|s| s.is_a?(Element) && s.name == "b"}
        this << Tag.build("span", "below") do |this|
          this["class"] << " #{color}" if color
          this << apply(element.get_elements("b").first, "slide", count)
        end
      end
    end
  end
  next this
end

converter.add(["large"], ["slide"]) do |element, _, count|
  this = ""
  this << Tag.build("div", "large") do |this|
    this.set_range(element, count)
    this << apply(element, "slide", count)
  end
  next this
end

converter.add(["em"], ["slide"]) do |element, _, count|
  this = ""
  color_index = element.attribute("c").to_s.to_i
  color = COLORS[color_index]
  this << Tag.build("span", "emphasis") do |this|
    this.set_range(element, count)
    this["class"] << " #{color}"
    this << apply(element, "slide", count)
  end
  next this
end