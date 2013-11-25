module Jekyll
  class BreakingImageTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      
      if text.split(" ").count > 1
        @path = text.split(" ").first
        @url = text.split(" ").last
      else
        @path = text
      end
      
    end

    def render(context)      
      image_url = @path
      pre = <<-eos      
</article>
</div>
</section>
<div style="background-color:white;">
<section class="container"><div class="row"><article class="content col-md-10 col-md-offset-1"><center>
eos

      post = <<-eos              
</center></article>
</div>
</section>
</div>    
<section class="container">
<div class="row">
<article class="content col-md-8 col-md-offset-2">
eos

      img = "<img src='#{image_url}'>"
      if @url
        img = "<a href='#{@url}'>" + img + "</a>"
      end

      return pre + img + post
    end
  end
end

Liquid::Template.register_tag('breaking_image', Jekyll::BreakingImageTag)

