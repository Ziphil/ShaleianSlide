# coding: utf-8


converter.add(["title-slide"], ["root"]) do |element, _, number|
  this = ""
  Tag.repeat(element) do |count|
    variables[:slide_count] = variables[:slide_count].to_i + 1
    this << Tag.build("div", "title-slide") do |this|
      this << Tag.new("div", "header")
      this << Tag.new("div", "footer")
      this << Tag.build("div", "content") do |this|
        this << Tag.build("div", "logo-wrapper") do |this|
          this << Tag.build("div", "logo") do |this|
            this << Tag.build("image") do |this|
              this["src"] = "../asset/logo.svg"
            end
          end
          this << Tag.build("div", "title-wrapper") do |this|
            this << Tag.build("div", "number") do |this|
              this << "第"
              this << Tag.build("span", "number") do |this|
                this << number.to_s
              end
              this << "課"
            end
            this << apply(element, "root", count)
          end
        end
      end
    end
  end
  next this
end

converter.add(["title"], ["root"]) do |element, _, count|
  this = ""
  this << Tag.build("div", "title") do |this|
    this.set_range(element, count)
    this << apply(element, "root", count)
  end
  next this
end