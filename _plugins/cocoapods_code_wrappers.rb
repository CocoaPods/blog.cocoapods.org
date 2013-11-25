module Jekyll
  module Converters
    class Markdown
      class RedcarpetParser

        module CommonMethods
          def add_code_tags(code, lang)
            
            pre = <<-eos      
      </article>
      </article>
      </section>
      
      <div style="background-color:white;">
      <section class="container">
      <article class="row">
      <article class="content col-md-8 col-md-offset-2">
            eos

            post = <<-eos              
      </article>
      </article>
      </section>
      </div>
      
      <section class="container">
      <article class="row">
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