Sweetie is a plugin for to get statistics for [jekyll](http://jekyllrb.com/ "jekyll") and
[middleman](https://middlemanapp.com/ "middleman") projects. The statistics includes the unique number of all links,
images, pages, and the last build time of the given project. You can specify the location the generated files
(normally `_site` for jekyll and `build` for middleman apps) and of the `config` file where the changes
will be written.


It can also grab the last changes of your bitbucket repositories. You can then use the information on various places in
your project

[![Gem Version](https://badge.fury.io/rb/sweetie.svg)](http://badge.fury.io/rb/sweetie)
[![CircleCI](https://circleci.com/gh/wikimatze/sweetie.svg?style=svg)](https://app.circleci.com/pipelines/github/wikimatze/sweetie)


## Toc

- [Installation](#installation)
- [Usage create stati](#usage-create-stati)
  - [Jekyll](#jekyll "Jekyll projects")
  - [Configuration variables for Jekyll](#configuration-variables-for-jekyll "Configuration variables for Jekyll")
  - [Middleman](#middleman "Middleman projects")
  - [Configuration variables for Middleman](#configuration-variables-for-middleman "Configuration variables for Middleman")
- [Usage bitbucket repositories](#usage-bitbucket-repositories "Usage bitbucket repositories")
  - [Middleman](#middleman-1 "Middleman")
  - [Jekyll](#jekyll-1 "Jekyll")


## Installation

```sh
$ gem install sweetie
```


## Usage create stati

### Jekyll

The easiest way is to add `require 'sweetie'` on the top of your Rakefile.

Before you build your page, you can run a rake task to update the status information of a page:


```ruby
require 'sweetie'

desc 'write stats in the _config.yml file'
task :create_stati do
  sweetie = Sweetie::Conversion.new('./site', './_config.yml')
  sweetie.create_stati
end
```


Make sure that the following fields are set in your `_config.yml`:


```yml
build:
htmlpages:
images:
links:
```


After running the script, the changes in `_config.yml` will look like:


```ruby
build: 6-18-2017
htmlpages: 600
images: 20
links: 271
```


### Configuration variables for Jekyll

You can use the `build`, `htmlpages`, `images`, and `links` variables defined in your `_config.yml` file everywhere in your page with the liquid snippet for example:


- `{{ site.build }}`
- `{{ site.htmlpages }}`
- `{{ site.images }}`
- `{{ site.links }}`


If you also make use of [Usage for Bitbucket repositories](#usage-for-bitbucket-repositories "Usage for Bitbucket repositories") you can also use the last update value for your repositories:


```html
<section class="lastupdate">
Last update {{ site.git }}
</section>
...


<section class="lastupdate">
Last update {{ site.pmwiki-twitter-recipe }}
</section>
...
```


will result the following html:


```html
<h3 id="git">Git</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>


<h3 id="twitter">Twitter</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>
```



### Middleman

The easiest way is to add `require 'sweetie'` on the top of your Rakefile.

Before you build your page, you can run a rake task to update the status information of a page:


```ruby
require 'sweetie'

desc 'write stats in the config.rb file'
task :create_stati do
  sweetie = Sweetie::Conversion.new('./build', './config.rb')
  sweetie.create_stati
end
```


Make sure that the following fields are set in your `config.rb`:


```yml
set :build,
set :images,
set :htmlpages,
set :links,
```


After running the script, the changes in `config.rb` will look like for example:


```ruby
set :build, 6-18-2017
set :images, 75
set :htmlpages, 111
set :links, 694
```


### Configuration variables for Middleman

You can use the `build`, `htmlpages`, `images`, and `links` variables defined in your `_config.yml` file everywhere in your page with the erb snippet for example:


- `<%= config[:build] %>
- `<%= config[:htmlpages] %>
- `<%= config[:images] %>
- `<%= config[:links] %>


If you also make use of [Usage for Bitbucket repositories](#usage-for-bitbucket-repositories "Usage for Bitbucket repositories") you can also use the last update value for your repositories:


```html

<section class="lastupdate">
Last update <%= config[:git] %>
</section>
...


<section class="lastupdate">
Last update <%= config[:pmwiki_twitter_recipe %>
</section>
...
```


will result the following html:


```html
<h3 id="git">Git</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>


<h3 id="twitter">Twitter</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>
```


## Usage Bitbucket repositories

### Middleman

The easiest way is to add `require 'sweetie'` on the top of your Rakefile.

Before you build your page, you can run a rake task to update the status of the repositories for the given `config-file` and `username`:


```ruby
require 'sweetie'

desc 'write repositories stats in the config.rb file'
task :create_bitbucket do
  stati_helper = Sweetie::BitbucketStatiHelper.new('./config.rb', 'wikimatze')
  bitbucket = Sweetie::Bitbucket.new(stati_helper)
  bitbucket.update_stati
end
```

Please note that you have to change `wikimatze` to your bitbucket user name


```ruby
set :pmwiki_dropcaps_recipe,
set :pmwiki_syntaxlove_recipe,
set :pmwiki_twitter_recipe,
set :pmwiki_linkicons_recipe,
set :pmwiki_headlineimage_recipe,
```


After running the script, the names in `config.rb` above will be changed to:


```ruby
set :pmwiki_dropcaps_recipe, 2017-02-24
set :pmwiki_syntaxlove_recipe, 2017-02-26
set :pmwiki_twitter_recipe, 2017-02-26
set :pmwiki_linkicons_recipe, 2017-02-26
set :pmwiki_headlineimage_recipe, 2017-02-25
```


### Jekyll

The easiest way is to add `require 'sweetie'` on the top of your Rakefile.

Before you build your page, you can run a rake task to update the status of the repositories for the given `config-file` and `username`:


```ruby
require 'sweetie'

desc 'write repositories stats in the _config.yml file'
desc 'write stats in the _config.yml'
task :create_bitbucket do
  stati_helper = Sweetie::BitbucketStatiHelper.new('./_config.yml', 'wikimatze')
  bitbucket = Sweetie::Bitbucket.new(stati_helper)
  bitbucket.update_stati
end
```

Please note that you have to change `wikimatze` to your bitbucket user name


```ruby
set :pmwiki_dropcaps_recipe,
set :pmwiki_syntaxlove_recipe,
set :pmwiki_twitter_recipe,
set :pmwiki_linkicons_recipe,
set :pmwiki_headlineimage_recipe,
```


After running the script, the names in `config.rb` above will be changed to:


```ruby
set :pmwiki_dropcaps_recipe, 2017-02-24
set :pmwiki_syntaxlove_recipe, 2017-02-26
set :pmwiki_twitter_recipe, 2017-02-26
set :pmwiki_linkicons_recipe, 2017-02-26
set :pmwiki_headlineimage_recipe, 2017-02-25
```

## License

This software is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).

© 2011-2022 Matthias Günther <matze@wikimatze.de>.
