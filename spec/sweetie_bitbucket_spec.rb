require 'sweetie/bitbucket'

describe Sweetie::Bitbucket do

  let(:current_dir) {File.dirname(__FILE__)}
  let(:user_repositories) {File.join(current_dir, 'source', 'bitbucket', 'user_repositories.json')}
  let(:user_repositories_expectation) {File.join(current_dir, 'source', 'bitbucket', 'user_repositories_expectation.txt')}
  let(:site_dir) {File.join(current_dir, 'source', 'site')}
  let(:config) {File.join(current_dir, "source", "_config.yml")}
  let(:svn_hash) {{"svn" => "2011-10-16"}}

  let(:bitbucket) {Sweetie::Bitbucket}

  it "should parse a json file" do
    changeset = File.open(user_repositories).read
    # gsub replace trailing newline at the end of the file
    changeset_expectation = File.open(user_repositories_expectation).read.gsub("\n", "")
    changeset = bitbucket.parse_json(changeset).to_s
    changeset.should == changeset_expectation
  end

  it "should get the names of the repositories" do
    json_repositories = File.open(user_repositories).read
    names = %w(pmwiki-headlineimage-recipe
               pmwiki-linkicons-recipe
               pmwiki-dropcaps-recipe
               pmwiki-syntaxlove-recipe
               pmwiki-twitter-recipe)
    bitbucket.get_repositories_changes(json_repositories).keys.should == names
  end

  it "should parse a timestamp" do
    timestamp = %Q(2011-04-20 11:31:39)
    bitbucket.parse_timestamp(timestamp).should == "2011-04-20"
  end

  it "should create a string representation of a repository" do
    repository = {"pmwiki" => "2011-10-26"}
    bitbucket.entry_text(repository.keys.first, repository.values.first).should == "pmwiki: 2011-10-26"
  end

  it "should repositories changes write_repository_changes" do
    hash = {"svn" => "2011-10-26", "pmwiki" => "2011-10-26"}
    bitbucket.config = config
    bitbucket.write_repository_changes(hash)
    config_yml_content = File.open(config).read
    config_yml_content.should include("svn: 2011-10-26")
    config_yml_content.should include("pmwiki: 2011-10-26")

    # remove variables from the text-file
    text = config_yml_content.gsub!("svn: 2011-10-26\n", "")
    text = config_yml_content.gsub!("pmwiki: 2011-10-26\n", "")
    config_yml_content = File.open(config, "w")
    config_yml_content.puts text
    config_yml_content.close
  end

end

