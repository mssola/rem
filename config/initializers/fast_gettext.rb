FastGettext.add_text_domain 'app', :path => 'locale', :type => :po
FastGettext.default_available_locales = ['en', 'es', 'ca']
FastGettext.default_text_domain = 'app'

I18n.default_locale = 'en'
