require 'sweetie/middleman'

describe Sweetie::Middleman do
  let(:current_dir) { File.dirname(__FILE__) }
  let(:build_dir) { File.join(current_dir, 'fixtures', 'build') }
  let(:index_page) { File.join(current_dir, 'fixtures', 'build', 'index.html') }
  let(:sweetie) { Sweetie::Middleman }

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

  it 'creates the correct build-time' do
    time = Time.now
    expected_time = "#{time.month}-#{time.day}-#{time.year}"
    expect(sweetie.build_time).to eq expected_time
  end
end

