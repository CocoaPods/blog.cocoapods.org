module Jekyll
  module SharedIncludeFilter
    def shared_include(input)
      current_dir = File.dirname(File.expand_path(__FILE__))
      shared_include = current_dir + "/../shared/includes/" + input + ".html"
      return File.read(shared_include)
    end
  end
end

Liquid::Template.register_filter(Jekyll::SharedIncludeFilter)

