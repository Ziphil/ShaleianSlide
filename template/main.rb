# coding: utf-8


TEMPLATE = File.read(File.join(BASE_PATH, "template/template.html"))

converter.add(["root"], [""]) do |element|
  header_string, main_string = "", "", ""
  number = element.attribute("number").to_s.to_i
  main_string << apply(element, "root", number)
  result = TEMPLATE.gsub(/#\{(.*?)\}/){instance_eval($1)}.gsub(/\r/, "")
  next result
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