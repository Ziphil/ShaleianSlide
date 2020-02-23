# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Selenium
include Zenithal

BASE_PATH = File.expand_path("..", File.dirname($0)).encode("utf-8")

Kernel.load(File.join(BASE_PATH, "converter/utility.rb"))
Encoding.default_external = "UTF-8"
$stdout.sync = true


class WholeSlideConverter

  OUTPUT_DIR = "out"
  DOCUMENT_DIR = "document"
  TEMPLATE_DIR = "template"

  IMAGE_SIZE = [1920, 1080]

  def initialize(args)
    options, rest_args = args.partition{|s| s =~ /^\-\w$/}
    if options.include?("-i")
      @mode = :image
    else
      @mode = :normal
    end
    @rest_args = rest_args
    @paths = create_paths
    @parser = create_parser
    @converter = create_converter
    @driver = create_driver
  end

  def execute
    case @mode
    when :image
      execute_image
    when :normal
      execute_normal
    end
  end

  def execute_normal
    @paths.each_with_index do |path, index|
      convert_normal(path)
    end
  end

  def execute_image
    @paths.each_with_index do |path, index|
      convert_image(path)
    end
    @driver.quit
  end

  def convert_normal(path)
    extension = File.extname(path).gsub(/^\./, "")
    output_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR).then(&method(:modify_extension))
    count_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR).gsub("slide", "image").gsub(".zml", ".txt")
    output_dir = File.dirname(output_path)
    count_dir = File.dirname(count_path)
    FileUtils.mkdir_p(output_dir)
    FileUtils.mkdir_p(count_dir)
    case extension
    when "zml"
      @parser.update(File.read(path))
      document = @parser.run
      @converter.update(document)
      output = @converter.convert
      count = @converter.variables[:slide_count].to_i.to_s
      File.write(output_path, output)
      File.write(count_path, count)
    when "scss"
      option = {}
      option[:style] = :expanded
      option[:filename] = path
      output = SassC::Engine.new(File.read(path), option).render
      File.write(output_path, output)
    when "js", "svg"
      output = File.read(path)
      File.write(output_path, output)
    end
  end

  def convert_image(path)
    page_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR).then(&method(:modify_extension))
    output_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR).gsub("slide", "image").gsub(".zml", "")
    count_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR).gsub("slide", "image").gsub(".zml", ".txt")
    output_dir = File.dirname(output_path)
    count = File.read(count_path).to_i
    FileUtils.mkdir_p(output_dir)
    @driver.navigate.to("file:///#{page_path}")
    @driver.manage.window.resize_to(*IMAGE_SIZE)
    @driver.execute_script("document.body.classList.add('simple');")
    count.times do |index|
      @driver.execute_script("document.querySelectorAll('*[class$=\\'slide\\']')[#{index}].scrollIntoView();")
      @driver.save_screenshot("#{output_path}-#{index}.png")
    end
  end

  def create_paths
    paths = []
    if @rest_args.empty?
      dirs = []
      dirs << File.join(BASE_PATH, DOCUMENT_DIR, "slide")
      dirs << File.join(BASE_PATH, DOCUMENT_DIR, "asset") if @mode == :normal
      dirs.each do |dir|
        Dir.each_child(dir) do |entry|
          if entry =~ /\.\w+$/
            paths << File.join(dir, entry)
          end
        end
      end
    else
      path = @rest_args.map{|s| s.gsub("\\", "/").gsub("c:/", "C:/")}[0].encode("utf-8")
      paths << path
    end
    return paths
  end

  def create_parser(main = true)
    parser = ZenithalParser.new("")
    parser.brace_name = "x"
    parser.bracket_name = "xn"
    parser.slash_name = "i"
    if main
      parser.register_macro("import") do |attributes, _|
        import_path = attributes["src"]
        import_parser = create_parser(false)
        import_parser.update(File.read(File.join(DOCUMENT_DIR, import_path)))
        document = import_parser.run
        import_nodes = (attributes["expand"]) ? document.root.children : [document.root]
        next import_nodes
      end
    end
    return parser
  end

  def create_converter
    converter = ZenithalConverter.new(nil, :text)
    Dir.each_child(TEMPLATE_DIR) do |entry|
      if entry.end_with?(".rb")
        binding = TOPLEVEL_BINDING
        binding.local_variable_set(:converter, converter)
        Kernel.eval(File.read(File.join(TEMPLATE_DIR, entry)), binding, entry)
      end
    end
    return converter
  end

  def create_driver
    if @mode == :image
      options = WebDriver::Chrome::Options.new
      options.add_argument("--headless")
      options.add_option("excludeSwitches", ["enable-logging"])
      driver = WebDriver.for(:chrome, options: options)
    else
      driver = nil
    end
    return driver
  end

  def modify_extension(path)
    result = path.clone
    result.gsub!(/\.zml$/, ".html")
    result.gsub!(/\.scss$/, ".css")
    result.gsub!(/\.ts$/, ".js")
    return result
  end

end


whole_converter = WholeSlideConverter.new(ARGV)
whole_converter.execute