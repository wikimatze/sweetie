require 'sweetie/helper'
require 'sweetie/bitbucket_stati_helper'
require 'json'

module Sweetie
  # The class to get the repositorie updates from Bitbucket
  class Bitbucket
    include Sweetie::Helper

    # A basic initialize method.
    #
    # @param bitbucket_stati_helper [BitbucketStatiHelper]
    # @return [BitbucketStatiHelper]
    def initialize(bitbucket_stati_helper)
      @bitbucket_stati_helper = bitbucket_stati_helper
    end

    # Wrapper to start all the other methods which will use methods
    # to write the changes of the bitbucket in the config file,
    # which can be configured in the BitbucketStatiHelper
    #
    # @return [nil]
    def update_stati
      json_repositories = @bitbucket_stati_helper.get_repositories
      repositories_change_hashs = @bitbucket_stati_helper.get_repositories_changes(json_repositories)
      @bitbucket_stati_helper.write_repository_changes(repositories_change_hashs)
    end
  end
end

