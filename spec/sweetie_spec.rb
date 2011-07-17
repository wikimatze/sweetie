require 'sweetie/conversion'

describe Sweetie::Conversion do
  before :each do
    current_dir = File.dirname(__FILE__)
    @about_page = File.join(current_dir, 'source', 'site', 'about.html')
    @site_dir = File.join(current_dir, 'source', 'site')
    @stati = Sweetie::Conversion
  end

  it "should count links of about.html page" do
    @stati.count_link_of_one_page(@about_page).should == 11
  end

  it "should count images of about.html page" do
    @stati.count_images_of_one_page(@about_page).should == 1
  end

  it "should count all html pages" do
    @stati.count_html_pages(@site_dir).should == 8
  end

  it "should count all links of all pages" do 
    @stati.count_all_links(@site_dir).should == 54
  end

  it "should count all images" do
    @stati.count_all_images(@site_dir).should == 1
  end
end
