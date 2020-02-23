# coding: utf-8


TEMPLATE = File.read(File.join(BASE_PATH, "template/template.html"))

converter.add(["root"], [""]) do |element|
  header_string, main_string = "", "", ""
  number = element.attribute("number").to_s.to_i
  main_string << apply(element, "root", number)
  result = TEMPLATE.gsub(/#\{(.*?)\}/){instance_eval($1)}.gsub(/\r/, "")
  next result
end

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
        this << apply(element, "root", count)
      end
    end
  end
  next this
end

converter.add(["x", "xn"], [//]) do |element, scope, *args|
  this = ""
  this << Tag.build("span", "sans") do |this|
    this << apply(element, scope, *args)
  end
  next this
end

converter.add(["i"], [//]) do |element, scope, *args|
  this = ""
  this << Tag.build("i") do |this|
    this << apply(element, scope, *args)
  end
  next this
end

converter.add_default(nil) do |text|
  this = ""
  this << text.to_s
  next this
end