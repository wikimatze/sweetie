require 'nokogiri'
require 'sweetie/helper'

module Sweetie
  class Conversion
    class << self
      @@config = '_config.yml'
      @@dir    = '_site'

      include Sweetie::Helper

      # Opens the config file and search after the specified parameters.
      # It saves the gathered information about the build-date, the links,
      # the images, and the number of html-pages in the jekyll project.
      def conversion
        check_config_and_directory_file(@@config, @@dir)

        file = File.open(@@config)
        text = ''
        while line = file.gets
          if line =~ /build:/
            text << "build: #{build_time}\n"
          elsif line =~ /htmlpages:/
            text << "htmlpages: #{count_all_html_pages(@@dir)}\n"
          elsif line =~ /images:/
            text << "images: #{count_all_images(@@dir)}\n"
          elsif line =~ /links:/
            text << "links: #{count_all_links(@@dir)}\n"
          else
            text << line
          end
        end
        file.close

        write_config(file, text)
      end

      # Counts the link of on html page
      # @param [page] the path of a html page
      # @return the number of unique links
      def count_link_of_one_page(page)
        perform_search_for_single_page('//a', [], page)
      end

      # Count the images of one html page
      # @param (see #self.count_link_of_one_page)
      # @return the number of unique images
      def count_images_of_one_page(page)
        perform_search_for_single_page('//img', [], page)
      end

      # Counts all html pages
      # @param [Dir] the path of the directory
      # @return [Fixnum] the number of unique html pages
      def count_all_html_pages(dir)
        perform_global_search('//html', [], dir)
      end

      # Counts all the links of all html pages
      # @param (see #self.count_all_html_pages)
      # @return (see #self.count_all_html_pages)
      def count_all_links(dir)
        perform_global_search('//a', [], dir)
      end

      # Counts all the images of all html pages
      # @param (see #self.count_all_html_pages)
      # @return (see #self.count_all_html_pages)
      def count_all_images(dir)
        perform_global_search('//img', [], dir)
      end

      # Create the actual build time
      # @return [String] in the date format mm-dd-yyyy
      def build_time
        time = Time.now
        "#{time.month}-#{time.day}-#{time.year}"
      end
    end
  end
end

