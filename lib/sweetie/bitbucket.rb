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

      # Wrapper to start all the other methods
      # @param [user] a valid bitbucket user
      def bitbucket(user)
        # json represetnation of user repositories
        json_repositories = get_repositories_json(user)

        # get the names of the repositories
        repositories_names = read_repositories(json_repositories)

        # get the hash with repository-name and last changes
        repositories_changes_hash = repositories_changes(user, repositories_names)

        # write the repository information in the _config.yml
        write_repository_changes(repositories_changes_hash)
      end

      # names of all repositories of a user
      # @param [json_repositories] repositories in json format
      # @return array with the names of all repositories of the user
      def read_repositories(json_repositories)
        repository_hash = parse_json(json_repositories)
        repositories_names = []

        repository_hash["repositories"].each do |repo|
          repositories_names << repo["name"]
        end

        repositories_names
      end

      # Get the last changes for each repository and the name
      # @param [user] a valid bitbucket user
      # @param [repositories] array with names of all repositories of a user
      # @return hash with all the repositories of the user and the last changes
      def repositories_changes(user, repositories)
        repositories_lastmodifications = {}
        repositories.each do |repository|
          changeset = repository_changeset(user, repository)
          repositories_lastmodifications.merge(repository_last_modification(repository, changeset))
        end

        repositories_lastmodifications
      end

      # Get the last modification of a repository
      # @param [repository_name] a valid repository name
      # @param [repository_json] json representation of the repository
      def repository_last_modification(repository_name, repository_json)
        changeset_parsed = parse_json(repository_json)
        timestamp = changeset_parsed["changesets"].last["timestamp"]

        # create the hash
        {repository_name => parse_timestamp(timestamp)}
      end

      # Parse JSON file to format be read by ruby
      def parse_json(file)
        JSON.parse file
      end

      # Get the changeset of a repository
      # @param [user] a valid bitbucket user
      # @param [repository] a repository of a user
      # @return information about the repository in json
      def repository_changeset(user, repository)
        `curl -s https://api.bitbucket.org/1.0/repositories/#{user}/#{repository}/changesets/`
      end

      # Get the json representation of each repository of the user
      # @param [user] a valid bitbucket user
      # @return json representation of all bitbucket repositories
      def get_repositories_json(user)
        `curl -s https://api.bitbucket.org/1.0/users/#{user}/`
      end

      # Parse timestamp to display only the date ("2011-04-20 11:31:39" will be converted to "2011-04-20")
      # @param [timestamp] a time display as a string in the 'Time.now' format
      # @return "yyyy-mm-dd"
      def parse_timestamp(timestamp)
        regex = Regexp.new(/(\d+)-(\d+)-(\d+)/)
        regex.match(timestamp)[0]
      end

      # Writes the changes into the _config.yml
      # @param [repositories] a hash with the following scheme {"svn" => "2011-10-26", "pmwiki" => "2011-10-26"}
      def write_repository_changes(repositories)
        repositories.each do |repository, last_change|
          file = File.open(@@config)
          text = ""
          match = false
          while line = file.gets
            if line.match(/#{repository}/)
              match = true
              # create string and replace this line with the new changes
              text << create_entry(repository, last_change) + "\n"
            else
              text << line
            end
          end

          # append the repository if it is not in there
          text << create_entry(repository, last_change) unless match

          file.close

          write_config(@@config, text)
        end
      end

      # Create a string representation of a repository entry
      # @param [repository_name] string contains the name of the repository
      # @param [last_change] string contains the date of the change
      # @return a string in the form "<reponame>: <date>"
      def create_entry(repository_name, last_change)
        "#{repository_name}: #{last_change}"
      end

    end

  end

end

