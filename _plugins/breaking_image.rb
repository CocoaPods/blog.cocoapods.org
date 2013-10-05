module Jekyll
  class BreakingImageTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @path = text
    end

    def render(context)      
      image_url = @path
      pre = <<-eos      
</article>
</section>
      
<div style="background-color:white;">
<section class="row container">
<article class="content col-md-8 col-md-offset-2">
      eos

      post = <<-eos              
</article>
</section>
</div>
      
<section class="container row">
<article class="content col-md-8 col-md-offset-2">
      eos

      img = "<img src='#{image_url}'>"

      return pre + img + post
    end
  end
end

Liquid::Template.register_tag('breaking_image', Jekyll::BreakingImageTag)

