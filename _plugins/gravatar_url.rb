module Jekyll
  module GravatarFilter
    def gravatar_url(input)
      "http://gravatar.com/avatar/#{ input }?s=48"
    end
  end
end

Liquid::Template.register_filter(Jekyll::GravatarFilter)

