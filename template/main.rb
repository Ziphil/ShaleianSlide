# coding: utf-8


converter.add(["root"], [""]) do |element|
  this = ""
  number = element.attribute("number").to_s.to_i
  this << apply(element, "root", number)
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

converter.add(["k"], ["slide"]) do |element, scope, *args|
  this = ""
  this << Tag.build("span", "japanese") do |this|
    this << apply(element, scope, *args)
  end
  next this
end

converter.add_default(nil) do |text|
  this = ""
  this << text.to_s
  next this
end