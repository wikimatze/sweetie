Gem::Specification.new do |gem|
	gem.name        = 'sweetie'
	gem.version     = '0.0.1'
	gem.date        = '2011-07-02'

	gem.summary     = 'Count pages, images, links, and last-build time of a jekyll project'
	gem.description = 'Sweetie count pages, images, links, and last-build time of a jekyll project'

	gem.authors     = ["Matthias Guenther"]
	gem.email       = 'matthias.guenther@wikimatze.de'
	gem.homepage    = 'http://github.com/matthias-guenther/sweetie'

	gem.files       = %w[lib/sweetie.rb]
	gem.executables << 'sweetie'

  gem.add_runtime_dependency('nokogiri', ">= 1.4.6")

  gem.add_development_dependency('rspec', ">= 2.6.0")
end
