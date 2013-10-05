module Jekyll
  module Converters
    class Markdown
      class RedcarpetParser

        module CommonMethods
          def add_code_tags(code, lang)
            
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
            
            code = code.sub(/<pre>/, pre + "<pre class='highlight'><code class=\"#{lang} language-#{lang}\" data-lang=\"#{lang}\">")
            code = code.sub(/<\/pre>/,"</code></pre>" + post)
          end
        end
      end
    end
  end
end