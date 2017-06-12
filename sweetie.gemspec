$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'sweetie/version'

Gem::Specification.new do |s|
  s.name                  = 'sweetie'
  s.version               = Sweetie::VERSION
  s.date                  = '2012-07-15'
  s.authors               = ['Matthias Guenther']
  s.email                 = 'matthias@wikimatze.de'
  s.homepage              = 'https://github.com/wikimatze/sweetie'
  s.summary               = 'Count links, images, number of html pages, and last-build time of a
                             jekyll project. In addition it can get last updates of all bitbucket
                             repositories of a user.'

  s.description           = 'Sweetie counts the links, images, number of html pages, and last-build
                             time of a jekyll project. In addition it can get the last changes of all
                             bitbuckets repositories of a user.'
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec}/*`.split("\n")

  s.extra_rdoc_files      = ['README.md']

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_development_dependency 'rake', '~> 10.2'
  s.add_development_dependency 'rspec', '~> 3.3'
end

