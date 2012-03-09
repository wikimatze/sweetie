module Sweetie
  require 'nokogiri'

  class Conversion

    @@config = "_config.yml"
    @@dir    = "_site"

    class << self
      # Opens the config file and search after the specified parameters.
      # It saves the gathered information about the build-date, the links,
      # the images, and the number of html-pages in the jekyll project.
      def change_config
        if !File.exist? @@config or !Dir.exist? @@dir
          raise "Can't find the _config.yml or the _site directory! Please create it!"
        end

        file = File.open(@@config)
        text = ""
        while line = file.gets
          if line.match(/build:/)
            text << "build: #{build_time}\n"
          elsif line.match(/htmlpages:/)
            text << "htmlpages: #{count_all_html_pages(@@dir)}\n"
          elsif line.match(/images:/)
            text << "images: #{count_all_images(@@dir)}\n"
          elsif line.match(/links:/)
            text << "links: #{count_all_links(@@dir)}\n"
          else
            text << line
          end
        end
        file.close
        File.open(@@config, 'w') do |file|
          file.puts text
          file.close
        end
      end

      # Counts the link of on html page
      # @param [page] the path of a html page
      # @return the number of unique links
      def count_link_of_one_page(page)
        links = []
        links = harvest('//a', page, links)
        output_count(links)
      end

      # Count the images of one html page
      # @param (see #self.count_link_of_one_page)
      # @return the number of unique images
      def count_images_of_one_page(page)
        images = []
        images = harvest('//img', page, images)
        output_count(images)
      end

      # Counts all html pages
      # @param [Dir] the path of the directory
      # @return [Fixnum] the number of unique html pages
      def count_all_html_pages(dir)
        pages = []
        traverse('//html', pages, dir)
        output_count(pages)
      end

      # Counts all the links of all html pages
      # @param (see #self.count_all_html_pages)
      # @return (see #self.count_all_html_pages)
      def count_all_links(dir)
        links = []
        traverse('//a', links, dir)
        output_count(links)
      end

      # Counts all the images of all html pages
      # @param (see #self.count_all_html_pages)
      # @return (see #self.count_all_html_pages)
      def count_all_images(dir)
        images = []
        traverse('//img', images, dir)
        output_count(images)
      end

      # Create the actual build time
      # @return [String] in the date format mm-dd-yyyy
      def build_time
        time = Time.now
        "#{time.month}-#{time.day}-#{time.year}"
      end

      # Traverse the jekyll directory and get the information about a specific
      # @param [Pattern] is a string for nokogiri after which the html pages should be parsed
      # @param [Ar] is an empty Array which is used by the harvest method
      # @param [Dir] the directory in which the html files are stored
      def traverse(pattern, ar, dir)
        Dir.glob(dir+"/**/*") do |file|
          next if file == '.' or file == '..' or file.include?("html~")
          if file.match(/(.*).html/)
            harvest(pattern, file, ar)
          end
        end
      end

      # Traverse each html page and gather information about the specified html element
      # @param [Pattern] important for nokogiri
      # @param [Html] the path for the html file
      # @param [Ar] and array which stores all the findings produces by nokogiri
      def harvest(pattern, html, ar)
        file = File.open(html)
        doc = Nokogiri::HTML(file)
        doc.xpath(pattern).each do |node|
          if pattern == "//a"
            ar << node.text
          elsif pattern == "//img" and ar.include?(node.to_s)
          elsif pattern == "//img"
            ar << node.to_s
          elsif pattern == "//html"
            ar << node
          else
          end
        end
        ar
      end

      # Count the elements
      # @param [Ar] is an array with all the found html parts
      def output_count(ar)
        ar.uniq.count # remove duplicates with uniq
      end
    end
  end
end

