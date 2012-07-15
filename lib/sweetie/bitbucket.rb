module Sweetie
  require 'sweetie/helper'

  class Bitbucket
    require 'json'

    @@config = "_config.yml"

    class << self
      include Sweetie::Helper

      # getter for class variable @@config
      def config
        @@config
      end

      # setter for the class variable @@config
      def config=(config)
        @@config = config
      end

      # Public: Wrapper to start all the other methods
      #
      # user - The String of the bitbucket user
      #
      # Example:
      #
      #   bitbucket('wikimatze')
      #
      # Returns nothing but write the changes in the _config.yml file
      def bitbucket(user)
        json_repositories = get_repositories(user)
        repositories_change_hashs = get_repositories_changes(json_repositories)
        write_repository_changes(repositories_change_hashs)
      end

      # Public: Fire up curl request to bitbucket
      #
      # user - The String of the bitbucket user
      #
      # Example:
      #
      #   bitbucket('wikimatze')
      #
      #   # =>
      #     {
      #         "repositories": [
      #             {
      #                 "scm": "git",
      #                 "has_wiki": false,
      #                 "last_updated": "2012-07-01 07:03:08",
      #                 "creator": null,
      #                 "created_on": "2012-07-01 07:03:08",
      #                 "owner": "wikimatze",
      #                 "logo": null,
      #                 "email_mailinglist": "",
      #                 "is_mq": false,
      #                 "size": 580,
      #                 "read_only": false,
      #                 "fork_of": null,
      #                 "mq_of": null,
      #                 "followers_count": 1,
      #                 "state": "available",
      #                 "utc_created_on": "2012-07-01 05:03:08+00:00",
      #                 "website": "",
      #                 "description": "",
      #                 "has_issues": false,
      #                 "is_fork": false,
      #                 "slug": "knoppix-6-01",
      #                 "is_private": false,
      #                 "name": "knoppix-6-01",
      #                 "language": "",
      #                 "utc_last_updated": "2012-07-01 05:03:08+00:00",
      #                 "email_writers": true,
      #                 "no_public_forks": false,
      #                 "resource_uri": "/1.0/repositories/wikimatze/knoppix-6-01"
      #             },
      #             ... other repositories
      #             }
      #         ],
      #         "user": {
      #             "username": "wikimatze",
      #             "first_name": "Matthias",
      #             "last_name": "Guenther",
      #             "avatar": "https://secure.gravatar.com/avatar/208673d619b63131cbfd7205366ad16e?d=identicon&s=32",
      #             "resource_uri": "/1.0/users/wikimatze"
      #         }
      #     }
      #
      # Returns a json representation the specified user
      def get_repositories(user)
        `curl -s https://api.bitbucket.org/1.0/users/#{user}/`
      end

      # Public: Grab for each repository the recent update
      #
      # json_repositories: A json object of the bitbucket API response
      #
      # Example:
      #
      #   get_repositories_changes(wikimatze_json)
      #   # => {"pmwiki-headlineimage-recipe"=>"2011-10-29", "pmwiki-linkicons-recipe"=>"2011-10-29"}
      #
      # Returns a hash of the form {repository_name => last_updated}
      def get_repositories_changes(json_repositories)
        repository_hash = parse_json(json_repositories)
        repositories_changsets = {}

        repository_hash["repositories"].each do |repository|
          repository_name = repository['name']
          repository_last_updated = parse_timestamp(repository['last_updated'])
          repositories_changsets.merge!({repository_name => repository_last_updated})
        end

        repositories_changsets
      end

      # Public: Wrapper for calling the json_parsing
      #
      # file: A String in JSON format
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
      #   # => {"user"=>{"username"=>"wikimatze", "first_name"=>"Matthias", "last_name"=>"Guenther", "resource_uri"=>"/1.0/users/wikimatze"}}
      #
      # Returns Parse JSON file to format be read by ruby
      def parse_json(json)
        JSON.parse(json)
      end

      # Public: Parse a timestamp in a wanted format
      #
      # timestamp - A string in the form 2011-04-20 11:31:39
      #
      # Example:
      #
      #   parse_timestamp("2011-04-20 11:31:39")
      #   # => 2011-04-20
      #
      # Returns a string in the format "yyyy-mm-dd"
      def parse_timestamp(timestamp)
        regex = Regexp.new(/(\d+)-(\d+)-(\d+)/)
        regex.match(timestamp)[0]
      end

      # Public: Parse a hash and write its key/value pairs in a file
      #
      # repositories - A hash in the form {<name> => <last_updated}
      #
      # Example:
      #
      #   write_repository_changes({"svn" => "2011-10-26", "pmwiki" => "2011-10-26"})
      #   # => svn: 2011-10-26\npmwiki: 2011-10-26
      #
      # Returns nothing but writes the information in the specified _config.yml file
      def write_repository_changes(repositories)
        repositories.each do |name, last_updated|
          file = File.open(@@config)
          text = ""
          match = false
          while line = file.gets
            if line.match(/#{name}/)
              match = true
              # create string and replace this line with the new changes
              text << entry_text(name, last_updated) + "\n"
            else
              text << line
            end
          end

          # append the name if it is not in there
          text << entry_text(name, last_updated) unless match

          file.close
          write_config(@@config, text)
        end
      end

      # Public: Create a string representation of a repository entry
      #
      # name - A string containing the name of the repository
      # last_updated - A string containing the date of the last change of the repo
      #
      # Example:
      #
      #   entry_text({"pmwiki" => "2011-10-26"}
      #   # => "pmwiki: 2011-10-26"
      #
      # Return a string in the form "<name>: <last_updated>"
      def entry_text(name, last_updated)
        "#{name}: #{last_updated}"
      end

    end # self
  end # Bitbucket
end # Sweetie

