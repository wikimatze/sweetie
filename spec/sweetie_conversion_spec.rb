require 'sweetie/conversion'

describe Sweetie::Conversion do
  let(:current_dir) { File.dirname(__FILE__) }

  describe 'Jekyll project' do
    let(:site_dir) { File.join(current_dir, 'fixtures', 'jekyll', 'site') }
    let(:about_page) { File.join(site_dir, 'about.html') }
    let(:site_config) { File.join(current_dir, 'fixtures', 'jekyll', '_config.yml') }
    let(:sweetie) { Sweetie::Conversion.new(site_dir, site_config) }

    it 'should count links of about.html page' do
      expect(sweetie.count_link_of_one_page(about_page)).to eq(11)
    end

    it 'should count images of about.html page' do
      expect(sweetie.count_images_of_one_page(about_page)).to eq 1
    end

    it 'should count all html pages' do
      expect(sweetie.count_all_html_pages(site_dir)).to eq 8
    end

    it 'should count all links of all pages' do
      expect(sweetie.count_all_links(site_dir)).to eq 54
    end

    it 'should count all images' do
      expect(sweetie.count_all_images(site_dir)).to eq 1
    end

    it 'creates the correct build-time' do
      time = Time.now
      expected_time = "#{time.month}-#{time.day}-#{time.year}"
      allow(time).to receive(:now).and_return(time)
      expect(sweetie.build_time).to eq expected_time
    end

    it 'does create stati for jekyll project' do
      config_yml_file = File.open(site_config, 'w')
      default_text = <<TEXT
htmlpages:
images:
links:

TEXT
      config_yml_file.write(default_text)
      config_yml_file.close

      sweetie.create_stati

      config_yml_file = File.open(site_config).readlines
      expected_config = File.open(File.join(current_dir, 'fixtures', 'jekyll', '_expected_config.yml')).readlines

      result = true
      config_yml_file.each do |e|
        if !expected_config.include? e
          result = false
        end
      end

      expect(result).to be_truthy
    end
  end

  describe 'Middleman project' do
    let(:build_dir) { File.join(current_dir, 'fixtures', 'middleman', 'build') }
    let(:site_config) { File.join(current_dir, 'fixtures', 'middleman', 'config.rb') }
    let(:index_page) { File.join(build_dir, 'index.html') }
    let(:sweetie) { Sweetie::Conversion.new(build_dir, File.join(current_dir, 'fixtures', 'middleman', 'config.rb' )) }

    subject { sweetie }

    it 'should count links of index-fixtues page' do
      expect(subject.count_link_of_one_page(index_page)).to eq 13
    end

    it 'should count images of index-fixtures page' do
      expect(subject.count_images_of_one_page(index_page)).to eq 2
    end

    it 'should count all html pages' do
      expect(subject.count_all_html_pages(build_dir)).to eq 52
    end

    it 'should count all links of all pages' do
      expect(subject.count_all_links(build_dir)).to eq 405
    end

    it 'should count all images' do
      expect(subject.count_all_images(build_dir)).to eq 10
    end

    it 'does create stati for middleman project' do
      config_yml_file = File.open(site_config, 'w')
      default_text = <<TEXT
set :htmlpages,
set :images,
set :links,

TEXT
      config_yml_file.write(default_text)
      config_yml_file.close

      sweetie.create_stati

      config_yml_file = File.open(site_config).readlines
      expected_config = File.open(File.join(current_dir, 'fixtures', 'middleman', 'expected_config.rb')).readlines

      result = true
      config_yml_file.each do |e|
        if !expected_config.include? e or e.empty?
          result = false
        end
      end

      expect(result).to be_truthy
    end
  end
end

