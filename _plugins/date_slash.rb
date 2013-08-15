module Jekyll
  module DateSlashFilter
    def date_slash(date)
       time(date).strftime("%d/%m/%Y")
    end
  end
end

Liquid::Template.register_filter(Jekyll::DateSlashFilter)

