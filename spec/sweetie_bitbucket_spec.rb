require 'sweetie/bitbucket'
require 'sweetie/bitbucket_stati_helper'

describe Sweetie::Bitbucket do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'repositories.json') }

  subject { Sweetie::Bitbucket.new }

  it 'will update_stati' do
    bitbucket_stati_helper = double('BitbucketStatiHelper')

    expected_repositories = File.open(repositories)
    expected_changesets = { 'pmwiki-linkicons-recipe' => '2017-02-26',
                            'pmwiki-dropcaps-recipe' => '2017-02-24',
                            'pmwiki-headlineimage-recipe' => '2017-02-25',
                            'pmwiki-syntaxlove-recipe' => '2017-02-26',
                            'pmwiki-twitter-recipe' => '2017-02-26',
                            'presentations' => '2017-01-15',
                            'vocabularly' => '2013-01-26',
                            'ruby-scripts' => '2014-05-25',
                            'rails-sample-app' => '2013-01-26' }

    expect(bitbucket_stati_helper).to receive(:get_repositories) { expected_repositories }
    expect(bitbucket_stati_helper).to receive(:get_repositories_changes).with(expected_repositories) { expected_changesets }
    expect(bitbucket_stati_helper).to receive(:write_repository_changes).with(expected_changesets)

    subject = Sweetie::Bitbucket.new(bitbucket_stati_helper)
    subject.update_stati
  end
end

