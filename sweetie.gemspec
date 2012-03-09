# magic line that ensures "../lib" is in the load path
$:.push File.expand_path("../lib", __FILE__)
require 'sweetie/version'

Gem::Specification.new do |s|
  s.name                  = 'sweetie'
  s.version               = Sweetie::VERSION
  s.date                  = '2012-03-09'
  s.authors               = ['Matthias Guenther']
  s.email                 = 'matthias.guenther@wikimatze.de'
  s.homepage              = 'https://github.com/matthias-guenther/sweetie'

  s.summary               = %q{Count links, images, number of html pages, and last-build time of a
                             jekyll project + last changes of bitbucket repositories.}
  s.description           = %q{Sweetie counts the links, images, number of html pages, and last-build
                             time of a jekyll project. In addition it can get the last changes of all
                             bitbuckets repositories of a certain user.}

  # the files included in the gem
  s.files                 = `git ls-files`.split("\n")
  # files that are used for the gem (the line supports TestUnit, MiniTest, RSpec, and Cucumber
  s.test_files            = Dir.glob "spec/**/*spec.rb"
  s.require_paths         = ["lib"]

  s.extra_rdoc_files      = ["README.md"]

  s.add_runtime_dependency 'nokogiri', ">= 1.4.6"
  s.add_runtime_dependency 'json', ">= 1.6.1"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
end

