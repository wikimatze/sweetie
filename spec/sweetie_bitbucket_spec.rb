require 'sweetie/bitbucket'

describe Sweetie::Bitbucket do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:user_repositories) { File.join(current_dir, 'fixtures', 'bitbucket', 'user_repositories.json') }
  let(:user_repositories_expectation) { File.join(current_dir, 'fixtures', 'bitbucket', 'user_repositories_expectation.txt') }
  let(:site_dir) { File.join(current_dir, 'fixtures', 'site') }
  let(:config) { File.join(current_dir, 'fixtures', '_config.yml') }
  let(:svn_hash) { { svn: '2011-10-16' } }

  let(:bitbucket) { Sweetie::Bitbucket }

  it 'should parse a json file' do
    changeset = File.open(user_repositories).read
    # gsub replace trailing newline at the end of the file
    changeset_expectation = File.open(user_repositories_expectation).read.delete("\n")
    changeset = bitbucket.parse_json(changeset).to_s
    expect(changeset).to eq changeset_expectation
  end

  it 'should get the names of the repositories' do
    json_repositories = File.open(user_repositories).read
    names = %w[pmwiki-headlineimage-recipe
               pmwiki-linkicons-recipe
               pmwiki-dropcaps-recipe
               pmwiki-syntaxlove-recipe
               pmwiki-twitter-recipe]
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

  it 'should repositories changes write_repository_changes' do
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

