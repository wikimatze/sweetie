Gem::Specification.new do |s|
  s.name        = 'sweetie'
  s.version     = '0.0.2'
  s.date        = '2011-07-05'

  s.summary     = 'Count links, images, number of html pages, and last-build time of a jekyll project.'
  s.description = 'Sweetie counts the links, images, number of html pages, and last-build time of a jekyll project.'

  s.authors     = ["Matthias Guenther"]
  s.email       = 'matthias.guenther@wikimatze.de'
  s.homepage    = 'http://github.com/matthias-guenther/sweetie'

  s.files       = %w[lib/sweetie.rb] + ["README.md", "Rakefile"]
  s.executables << 'sweetie'

  s.add_runtime_dependency('nokogiri', ">= 1.4.6")

  s.add_development_dependency('rspec', ">= 2.6.0")
end
