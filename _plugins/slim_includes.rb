require 'tilt'
require 'slim'

module Jekyll
  class RenderTiltTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      
      # Inserts an underscore after the last / in a path, or the beginning if no / is found.
      # Examples:
      #   aaa.slim -> _aaa.slim
      #   bbb/aaa.slim -> bbb/_aaa.slim
      #
      @path = text.strip.gsub /(?!\/)([^\/]+)\z/, '_\1'
    end

    def render(context)
      current_dir = File.dirname(File.expand_path(__FILE__))
      shared_include = current_dir + "/../shared/includes/" + @path + ".slim"

      template = Tilt::new shared_include
      template.render context.registers
    end
  end
end

Liquid::Template.register_tag('shared_include', Jekyll::RenderTiltTag)

