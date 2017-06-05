require 'sweetie/helper'
require 'nokogiri'

describe 'Sweetie Helper' do
  let(:helper) { Class.new }

  before { helper.extend Sweetie::Helper }
  subject { helper }

  describe '#check_config_and_directory_file' do
    it 'raise an error if config file does not exists' do
      expect {subject.check_config_and_directory_file('not_here.txt')}.
        to raise_error.with_message("Can't find the _config.yml or the _site directory! Please create these files it!")
    end

    it 'raise an error if dir folder does not exists' do
      expect(File).to receive(:exist?).and_return(false)
      expect {subject.check_config_and_directory_file('', 'not_here/')}.
        to raise_error.with_message("Can't find the _config.yml or the _site directory! Please create these files it!")
    end
  end

  describe '#write_config' do
    it 'write results into file' do
      file = double(File)
      text = 'Hello config'
      expect(File).to receive(:open).with(file, 'w').and_yield file
      expect(file).to receive(:puts).with('Hello config')
      expect(file).to receive(:close)

      subject.write_config(file, 'Hello config')
    end
  end

  describe '#output_count' do
    it 'counts returns the number of arguments in the given array' do
      test_aray = [1,2,3]
      expect(subject.output_count(test_aray)).to eql 3
    end
  end

  describe '#harvest' do
    it 'find all links' do
      file = double(File)
      file_content =<<-TEXT
<a href="/index.html">wikimatze</a>
<a href="http://0.0.0:4000/contact.html" title="contact me">contact me</a>
      TEXT
      expect(File).to receive(:open).with(file).and_return(file_content)

      result = []
      expected_result = ['wikimatze', 'contact me']
      expect(subject.harvest('//a', file, result)).to eql expected_result
    end

    it 'find all images' do
      file = double(File)
      file_content =<<-TEXT
<img src="/images/images-global/matthias_guenther_thumbnail_small.jpg" alt="matthias_guenther.jpg" style="float:right; padding-left:10px;"/>
      TEXT

      expect(File).to receive(:open).with(file).and_return(file_content)

      result = []
      expected_result = ["<img src=\"/images/images-global/matthias_guenther_thumbnail_small.jpg\" alt=\"matthias_guenther.jpg\" style=\"float:right; padding-left:10px;\">"]
      expect(subject.harvest('//img', file, result)).to eql expected_result
    end

    it 'find all html pages' do
      file = double(File)
      file_content =<<-TEXT
      test
      TEXT

      expect(File).to receive(:open).with(file).and_return(file_content)

      result = []
      expected_result = ["<html><body><p>test </p></body></html>"]
      expect(subject.harvest('//html', file, result).count).to eql 1
    end
  end
end
