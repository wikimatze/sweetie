require 'sweetie/helper'
require 'json'
require 'pry'

module Sweetie
  class BitbucketStatiHelper
    include Sweetie::Helper

    attr_writer :config, :user

    # A basic initialize method.
    #
    # @param config [String] The config file in which the changes should be written
    # @param user [String] The name of the user for which the updates should be fetched
    # @return [nil]
    def initialize(config = '_config.yml', user = '')
      @config = config
      @user = user
    end

    # Grab for each repository the recent update
    #
    # @param json_repositories [String]: A json object of the bitbucket API response
    # @return [Hash] Returns a hash of the form {repository_name => last_updated}
    #
    # Example:
    #
    #   get_repositories_changes(wikimatze_json)
    #   # => {"pmwiki-headlineimage-recipe"=>"2011-10-29", "pmwiki-linkicons-recipe"=>"2011-10-29"}
    #
    def get_repositories_changes(json_repositories)
      repository_hash = parse_json(json_repositories)
      repositories_changsets = {}

      repository_hash['values'].each do |repository|
        repository_name = repository['name']
        repository_last_updated = parse_timestamp(repository['updated_on'])
        repositories_changsets.merge!(repository_name => repository_last_updated)
      end

      repositories_changsets
    end

    # Wrapper for calling the json_parsing from JSON library
    #
    # @param json [String]: A JSON format from the bitbucket API response
    # @return Returns Parse JSON file as a hash 2017-06-18
    #
    # Example:
    #
    #   json = {
    #     "user": {
    #       "username": "wikimatze",
    #       "first_name": "Matthias",
    #       "last_name": "Guenther",
    #       "resource_uri": "/1.0/users/wikimatze"
    #     }
    #   }
    #   parse_json(json)
    #   => {"user"=>{"username"=>"wikimatze", "first_name"=>"Matthias", "last_name"=>"Guenther", "resource_uri"=>"/1.0/users/wikimatze"}}
    #
    def parse_json(json)
      JSON.parse(json)
    end

    # Parse a hash and write its key/value pairs in a config file for jekyll and middleman projects
    #
    # @param repositories [Hash]- A hash in the form {<name> => <last_updated}
    # @return [nil] Writes the of the repository hash specified _config.yml by the given @config variable
    #
    # Example:
    #
    #   write_repository_changes({"svn" => "2011-10-26", "pmwiki" => "2011-10-26"})
    #   # => svn: 2011-10-26\npmwiki: 2011-10-26
    def write_repository_changes(repositories)
      repositories.each do |name, last_updated|
        file = File.open(@config)
        text = ''
        project = 'middleman'

        if File.extname(file) =~ /.yml/
          project = 'jekyll'
        end

        name = name.to_s.gsub('-', '_')
        while line = file.gets
          if line =~ /#{name}/ && project == 'middleman'
            text << entry_text_middleman(name, last_updated) + "\n"
          elsif line =~ /#{name}/ && project == 'jekyll'
            text << entry_text_jekyll(name, last_updated) + "\n"
          else
            text << line
          end
        end

        file.close
        write_config(@config, text)
      end
    end

    # Parse a timestamp
    #
    # @param timestamp [String] A string in the form 2011-04-20 11:31:39
    # @return [String] A string in the format "yyyy-mm-dd"
    #
    # Example:
    #
    #   parse_timestamp("2011-04-20 11:31:39")
    #   # => 2011-04-20
    #
    def parse_timestamp(timestamp)
      regex = Regexp.new(/(\d+)-(\d+)-(\d+)/)
      regex.match(timestamp)[0]
    end

    # Create a string representation of a repository entry in middleman style
    #
    # @param name [String] A string containing the name of the repository
    # @param updated [String] A string containing the date of the last change of the repo
    # @return [String] Return a string in the form "set :<name> :<last_updated>"
    #
    # Example:
    #
    #   entry_text_middleman({"pmwiki" => "2011-10-26"}
    #   # => "set :pmwiki 2011-10-26"
    def entry_text_middleman(name, updated)
      "set :#{name}, #{updated}"
    end

    # Create a string representation of a repository entry in jekyll style
    #
    # @param name [String] A string containing the name of the repository
    # @param updated [String] A string containing the date of the last change of the repo
    # @return [String] Return a string in the form "set :<name> :<last_updated>"
    #
    # Example:
    #
    #   entry_text_middleman({"pmwiki" => "2011-10-26"}
    #   # => "pmwiki: 2011-10-26"
    def entry_text_jekyll(name, updated)
      "#{name}: #{updated}"
    end

    # Fire up curl request to bitbucket
    #
    # @param user [String] Name of the bitbucket user
    #
    # Example:
    #
    #   bitbucket('wikimatze')
    #
    #   # =>
    #     {
    #      "pagelen":10,
    #      "values":[
    #          {
    #            "scm":"git",
    #            "website":"",
    #            "has_wiki":false,
    #            "name":"pmwiki-linkicons-recipe",
    #            "links":{
    #               "watchers":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/watchers"
    #               },
    #               "branches":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/refs/branches"
    #               },
    #               "tags":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/refs/tags"
    #               },
    #               "commits":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/commits"
    #               },
    #               "clone":[
    #                  {
    #                     "href":"https://bitbucket.org/wikimatze/pmwiki-linkicons-recipe.git",
    #                     "name":"https"
    #                  },
    #                  {
    #                     "href":"ssh://git@bitbucket.org/wikimatze/pmwiki-linkicons-recipe.git",
    #                     "name":"ssh"
    #                  }
    #               ],
    #               "self":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe"
    #               },
    #               "html":{
    #                  "href":"https://bitbucket.org/wikimatze/pmwiki-linkicons-recipe"
    #               },
    #               "avatar":{
    #                  "href":"https://bitbucket.org/wikimatze/pmwiki-linkicons-recipe/avatar/32/"
    #               },
    #               "hooks":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/hooks"
    #               },
    #               "forks":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/forks"
    #               },
    #               "downloads":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/downloads"
    #               },
    #               "pullrequests":{
    #                  "href":"https://api.bitbucket.org/2.0/repositories/wikimatze/pmwiki-linkicons-recipe/pullrequests"
    #               }
    #            },
    #            "fork_policy":"allow_forks",
    #            "uuid":"{182b19dc-334d-40d7-a65d-a85aaeb46f31}",
    #            "language":"",
    #            "created_on":"2011-10-07T21:01:39.266805+00:00",
    #            "mainbranch":{
    #               "type":"branch",
    #               "name":"master"
    #            },
    #            "full_name":"wikimatze/pmwiki-linkicons-recipe",
    #            "has_issues":false,
    #            "owner":{
    #               "username":"wikimatze",
    #               "display_name":"Matthias Günther",
    #               "type":"user",
    #               "uuid":"{5eab05fd-a541-43c5-a0e1-5bc9b2e2005f}",
    #               "links":{
    #                  "self":{
    #                     "href":"https://api.bitbucket.org/2.0/users/wikimatze"
    #                  },
    #                  "html":{
    #                     "href":"https://bitbucket.org/wikimatze/"
    #                  },
    #                  "avatar":{
    #                     "href":"https://bitbucket.org/account/wikimatze/avatar/32/"
    #                  }
    #               }
    #            },
    #            "updated_on":"2017-02-26T07:09:52.048642+00:00",
    #            "size":431470,
    #            "type":"repository",
    #            "slug":"pmwiki-linkicons-recipe",
    #            "is_private":false,
    #            "description":""
    #          },
    #         ...
    #      ],
    #    "page":1,
    #    "size":9
    #   }
    def get_repositories
      `curl -s https://api.bitbucket.org/2.0/repositories/#{@user}/`
    end
  end
end
