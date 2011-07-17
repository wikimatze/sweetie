require 'lib/sweetie'

Gem::Specification.new do |s|
  s.name                  = 'sweetie'
  s.version               = Sweetie::VERSION
  s.date                  = Sweetie::DATE

  s.summary               = 'Count links, images, number of html pages, and last-build time of a jekyll project.'
  s.description           = 'Sweetie counts the links, images, number of html pages, and last-build time of a jekyll project.'

  s.authors               = ["Matthias Guenther"]
  s.email                 = 'matthias.guenther@wikimatze.de'
  s.homepage              = 'http://github.com/matthias-guenther/sweetie'

  s.required_ruby_version = '>= 1.8.7'
  s.files                 = %w[lib/sweetie.rb] + ["README.md", "Rakefile"]

  s.test_files            = Dir.glob "spec/**/*spec.rb"

  s.add_runtime_dependency 'nokogiri', ">= 1.4.6"

  s.add_development_dependency 'rspec', ">= 2.6.0"
  s.add_development_dependency 'yard'
end
