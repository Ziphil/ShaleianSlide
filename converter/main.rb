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

  def initialize(args)
    options, rest_args = args.partition{|s| s =~ /^\-\w$/}
    if options.include?("-i")
      @mode = :image
    else
      @mode = :normal
    end
    @rest_args = rest_args
    @paths = create_paths
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

  def convert_normal(path)
    extension = File.extname(path).gsub(/^\./, "")
    output_path = path.gsub(DOCUMENT_DIR, OUTPUT_DIR)
    output_path = modify_extension(output_path)
    case extension
    when "zml"
      parser = create_parser(path)
      converter = create_converter(parser.run)
      output = converter.convert
      File.write(output_path, output)
    when "scss"
      option = {}
      option[:style] = :expanded
      option[:filename] = path
      output = SassC::Engine.new(File.read(path), option).render
      File.write(output_path, output)
    end
  end

  def convert_screenshot(path)
    size = 8
    options = WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    Parallel.each(0...size, in_threads: size) do |count|
      driver = WebDriver.for(:chrome, options: options)
      driver.navigate.to("file:///#{BASE_PATH}/out/main.html")
      driver.manage.window.resize_to(1008, 567)
      driver.execute_script("document.querySelectorAll('.slide')[#{count}].scrollIntoView();")
      driver.save_screenshot("out_#{count}.png")
      driver.quit
    end
  end

  def create_paths
    paths = []
    if @rest_args.empty?
      dirs = []
      dirs << File.join(DOCUMENT_DIR, "manuscript")
      dirs << File.join(DOCUMENT_DIR, "style")
      dirs.each do |dir|
        Dir.each_child(dir) do |entry|
          if entry =~ /\.\w+$/
            paths << File.join(dir, entry)
          end
        end
      end
    end
    return paths
  end

  def create_parser(path, main = true)
    source = File.read(path)
    parser = ZenithalParser.new(source)
    parser.brace_name = "x"
    parser.bracket_name = "xn"
    parser.slash_name = "i"
    if main
      parser.register_macro("import") do |attributes, _|
        import_path = attributes["src"]
        import_parser = create_parser(File.join(DOCUMENT_DIR, import_path), false)
        document = import_parser.parse
        import_nodes = (attributes["expand"]) ? document.root.children : [document.root]
        next import_nodes
      end
    end
    return parser
  end

  def create_converter(document)
    converter = ZenithalConverter.new(document, :text)
    Dir.each_child(TEMPLATE_DIR) do |entry|
      if entry.end_with?(".rb")
        binding = TOPLEVEL_BINDING
        binding.local_variable_set(:converter, converter)
        Kernel.eval(File.read(File.join(TEMPLATE_DIR, entry)), binding, entry)
      end
    end
    return converter
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