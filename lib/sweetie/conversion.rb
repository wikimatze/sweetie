require 'nokogiri'
require 'sweetie/helper'

module Sweetie
  # The class which can get the stati of the project including number of html pages, images, and links
  class Conversion
    include Sweetie::Helper

    # A basic initialize method.
    #
    # @param dir [String] The directoy in which should search after links, images and number of HTML pages
    # @param config [String] The name of the config file in which the results should be written
    # @return [nil]
    def initialize(dir = '_site', config = '_config.yml')
      @dir = dir
      @config = config
    end

    # It saves the gathered information about the build-date, the links,
    # the images, and the number of html-pages in the jekyll project.
    #
    # @return [nil]
    def create_stati
      check_directory_and_config_file(@dir, @config)

      file = File.open(@config)
      text = ''
      if File.extname(file) =~ /.rb/
        while line = file.gets
          text << if line =~ /set :build,/
                    "set :build, '#{build_time}'\n"
                  elsif line =~ /set :htmlpages,/
                    "set :htmlpages, #{count_all_html_pages(@dir)}\n"
                  elsif line =~ /set :images,/
                    "set :images, #{count_all_images(@dir)}\n"
                  elsif line =~ /set :links,/
                    "set :links, #{count_all_links(@dir)}\n"
                  else
                    line
                  end
        end
      else
        while line = file.gets
          text << if line =~ /build:/
                    "build: '#{build_time}'\n"
                  elsif line =~ /htmlpages:/
                    "htmlpages: #{count_all_html_pages(@dir)}\n"
                  elsif line =~ /images:/
                    "images: #{count_all_images(@dir)}\n"
                  elsif line =~ /links:/
                    "links: #{count_all_links(@dir)}\n"
                  else
                    line
                  end
        end
      end

      file.close

      write_config(file, text)
    end

    # Counts the link of on html page.
    #
    # @param page [String] The path of a html page
    # @return [Integer] The number of unique links for the given page
    def count_link_of_one_page(page)
      perform_search_for_single_page('//a', [], page)
    end

    # Count the images of one html page.
    #
    # @param page [String] The path of a html page
    # @return [Integer] The number of unique images for the given page
    def count_images_of_one_page(page)
      perform_search_for_single_page('//img', [], page)
    end

    # Counts all html pages for the given directory.
    #
    # @param dir [String] The path of the directory
    # @return [Integer] The number of unique html pages
    def count_all_html_pages(dir)
      perform_global_search('//html', [], dir)
    end

    # Counts all the links for the given directory.
    #
    # @param dir [String] The path of the directory
    # @return [Integer] The number of unique links for the given dir
    def count_all_links(dir)
      perform_global_search('//a', [], dir)
    end

    # Counts all the images for the given directory.
    #
    # @param dir [String] The path of the directory
    # @return [Integer] The number of all images for the given dir
    def count_all_images(dir)
      perform_global_search('//img', [], dir)
    end

    # Create the actual build time.
    #
    # @return [String] in the date format mm-dd-yyyy
    def build_time
      time = Time.now
      "#{time.month}-#{time.day}-#{time.year}"
    end
  end
end

