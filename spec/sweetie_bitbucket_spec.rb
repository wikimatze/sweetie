require 'sweetie/bitbucket'

describe Sweetie::Bitbucket do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'repositories.json') }
  let(:expected_repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'expected_repositories.txt') }
  let(:site_dir) { File.join(current_dir, 'fixtures', 'jekyll', 'site') }
  let(:config) { File.join(current_dir, 'fixtures', 'jekyll', '_config.yml') }
  let(:svn_hash) { { svn: '2011-10-16' } }

  let(:bitbucket) { Sweetie::Bitbucket }

  it 'should parse a json file' do
    # gsub replace trailing newline at the end of the file
    changeset_expectation = File.open(expected_repositories).read.delete("\n")
    changeset = File.open(repositories).read
    changeset = bitbucket.parse_json(changeset).to_s
    expect(changeset).to eq changeset_expectation
  end

  it 'should get the names of the repositories' do
    json_repositories = File.open(repositories).read
    names = ["pmwiki-linkicons-recipe",
             "pmwiki-dropcaps-recipe",
             "pmwiki-headlineimage-recipe",
             "pmwiki-syntaxlove-recipe",
             "pmwiki-twitter-recipe",
             "presentations",
             "vocabularly",
             "ruby-scripts",
             "rails-sample-app"
            ]
    expect(bitbucket.get_repositories_changes(json_repositories).keys).to eq names
  end

  it 'should parse a timestamp' do
    timestamp = '2011-04-20 11:31:39'
    expect(bitbucket.parse_timestamp(timestamp)).to eq '2011-04-20'
  end

  it 'should create a string representation of a repository' do
    repository = { pmwiki: '2011-10-26' }
    expect(bitbucket.entry_text(repository.keys.first, repository.values.first)).to eq 'pmwiki: 2011-10-26'
  end

  it 'write repository changes to ' do
    hash = { svn: '2011-10-26', pmwiki: '2011-10-26' }
    bitbucket.config = config
    bitbucket.write_repository_changes(hash)
    config_yml_content = File.open(config).read
    expect(config_yml_content).to include 'svn: 2011-10-26'
    expect(config_yml_content).to include 'pmwiki: 2011-10-26'

    # remove variables from the text-file
    text = config_yml_content.delete("svn: 2011-10-26\n")
    text = config_yml_content.delete("pmwiki: 2011-10-26\n")
    config_yml_content = File.open(config, 'w')
    config_yml_content.puts text
    config_yml_content.close
  end
end

