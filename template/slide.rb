# coding: utf-8


converter.add(["slide"], ["root"]) do |element, _, number|
  this = ""
  repeat = element.attribute("repeat").to_s.to_i
  slide_number = element.attribute("number").to_s.to_i
  repeat.times do |count|
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
        this << apply(element, "root", count)
      end
    end
  end
  next this
end

converter.add(["xl"], ["root"]) do |element, _, count|
  this = ""
  this << Tag.build("ul", "conlang") do |this|
    this.apply_count(element, count)
    this << apply(element, "root.xl", count)
  end
  next this
end

converter.add(["li"], ["root.xl"]) do |element, _, count|
  this = ""
  this << Tag.build("li") do |this|
    this.apply_count(element, count)
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
    this.apply_count(element, count)
    this << Tag.build("li") do |this|
      this << apply(element, "root", count)
    end
  end
  next this
end

converter.add(["ver"], ["root"]) do |element, _, count|
  this = ""
  color = element.attribute("color")&.to_s || "blue"
  this << Tag.build("span", "vertical") do |this|
    this.apply_count(element, count)
    this["class"] << " #{color}"
    this << Tag.build("span", "above") do |this|
      this << apply(element.get_elements("ab").first, "root", count)
    end
    this << Tag.build("span", "box-wrapper") do |this|
      this << Tag.build("span", "box") do |this|
        this << apply(element.get_elements("bx").first, "root", count)
      end
      this << Tag.build("span", "below") do |this|
        this << apply(element.get_elements("bl").first, "root", count)
      end
    end
  end
  next this
end

converter.add(["large"], ["root"]) do |element, _, count|
  this = ""
  this << Tag.build("div", "large") do |this|
    this.apply_count(element, count)
    this << apply(element, "root", count)
  end
  next this
end

converter.add(["em"], ["root"]) do |element, _, count|
  this = ""
  color = element.attribute("color")&.to_s || "blue"
  this << Tag.build("span", "emphasis") do |this|
    this.apply_count(element, count)
    this["class"] << " #{color}"
    this << apply(element, "root", count)
  end
  next this
end