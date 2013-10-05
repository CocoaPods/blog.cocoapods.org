require 'tilt'
require 'slim'

module Jekyll
  class RenderTiltTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @path = text
    end

    def render(context)      
      current_dir = File.dirname(File.expand_path(__FILE__))
      shared_include = current_dir + "/../shared/includes/" + @path.strip + ".slim"

      template = Tilt::new shared_include
      template.render context.registers
    end
  end
end

Liquid::Template.register_tag('shared_include', Jekyll::RenderTiltTag)

