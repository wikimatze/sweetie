Sweetie is a plugin for [jekyll](https://github.com/mojombo/jekyll) to count all links, images, pages, and the last build time on a jekyll site. You can then use this information at a any place in your jekyll project.
[![Travis](http://travis-ci.org/matthias-guenther/sweetie.png)](http://travis-ci.org/matthias-guenther/sweetie)


## Configuration variables
To get the plugin working you must add `build`, `htmlpages`, `images`, and `links` in your `_config.yml` file. _sweetie_ will save the information to this variables. You can then use them everywhere in your page with the liquid snippet for example: 

* `{{ site.build }}`
* `{{ site.htmlpages }}`
* `{{ site.images }}`
* `{{ site.links }}`

on all of your pages.


## Installation
Put the `sweetie.rb` file in the root of your jekyll project and then run the file to update your `_config.yml`file. To get the right calculated number of html pages, your pages must have the file ending *.html.


## Possible usage
Before you deploy your page, you can run the `sweetie.rb` in a rake task:

	desc "deploy"
	task :create_stati do
	  system("sweetie")
	end

