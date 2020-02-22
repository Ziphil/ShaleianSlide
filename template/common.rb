# coding: utf-8


COLORS = {1 => "blue", 2 => "orange", 3 => "pink", 4 => "green"}

converter.add(["xl"], ["root"]) do |element, _, count|
  this = ""
  this << Tag.build("ul", "conlang") do |this|
    this.set_range(element, count)
    this << apply(element, "root.xl", count)
  end
  next this
end

converter.add(["li"], ["root.xl"]) do |element, _, count|
  this = ""
  this << Tag.build("li") do |this|
    this.set_range(element, count)
    this << apply(element, "root.xl.li", count)
  end
  next this
end

converter.add(["sh"], ["root.xl.li"]) do |element, _, count|
  this = ""
  this << apply(element, "root", count)
  next this
end

converter.add(["ja"], ["root.xl.li"]) do |element, _, count|
  this = ""
  this << Tag.build("ul") do |this|
    this.set_range(element, count)
    this << Tag.build("li") do |this|
      this << apply(element, "root", count)
    end
  end
  next this
end

converter.add(["table"], ["root"]) do |element, scope|
  this = ""
  this << Tag.build("table") do |this|
    this << apply(element, "root.table")
  end
  next this
end

converter.add(["tr"], ["root.table"]) do |element|
  this = ""
  this << Tag.build("tr") do |this|
    this << apply(element, "root.table.tr")
  end
  next this
end

converter.add(["th", "td"], ["root.table.tr"]) do |element|
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
    this << apply(element, "root")
  end
  next this
end

converter.add(["ver"], ["root"]) do |element, _, count|
  this = ""
  color_index = element.attribute("color")&.to_s&.to_i || 1
  color = COLORS[color_index]
  this << Tag.build("span", "vertical") do |this|
    this.set_range(element, count)
    this << Tag.build("span", "above") do |this|
      this["class"] << " #{color}"
      this << apply(element.get_elements("ab").first, "root", count)
    end
    this << Tag.build("span", "below-wrapper") do |this|
      this << Tag.build("span", "center") do |this|
        this << Tag.build("span", "box") do |this|
          this["class"] << " #{color}"
          this << apply(element.get_elements("bx").first, "root", count)
        end
      end
      this << Tag.build("span", "below") do |this|
        this["class"] << " #{color}"
        this << apply(element.get_elements("bl").first, "root", count)
      end
    end
  end
  next this
end

converter.add(["large"], ["root"]) do |element, _, count|
  this = ""
  this << Tag.build("div", "large") do |this|
    this.set_range(element, count)
    this << apply(element, "root", count)
  end
  next this
end

converter.add(["em"], ["root"]) do |element, _, count|
  this = ""
  color_index = element.attribute("color")&.to_s&.to_i || 1
  color = COLORS[color_index]
  this << Tag.build("span", "emphasis") do |this|
    this.set_range(element, count)
    this["class"] << " #{color}"
    this << apply(element, "root", count)
  end
  next this
end