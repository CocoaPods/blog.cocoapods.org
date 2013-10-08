module Jekyll
  module GravatarFilter
    def gravatar_url(input)
      "http://gravatar.com/avatar/#{ input }?s=144"
    end
  end
end

Liquid::Template.register_filter(Jekyll::GravatarFilter)

