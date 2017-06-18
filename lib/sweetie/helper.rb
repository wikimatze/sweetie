module Sweetie
  # The Helper module which can get the stati of the project including number of html pages, images, and links
  module Helper
    # Traverse the page after the pattern and return the number of occurences on it
    #
    # @param pattern [String] need for nokogiri to parse the html page
    # @param arr [Array] array to save the results
    # @param page [String] The path to a file which will be taken for the search
    def perform_search_for_single_page(pattern, arr, page)
      harvest(pattern, page, arr)
      output_count(arr)
    end

    # Traverse each html page and gather information about the specified html element
    #
    # @param pattern [String] The xpath regular for Nokogiri expressions after which the HTML is grabbed
    # @param html [String] An array to save the results
    # @param arr [Array] An array which stores all the findings produces by nokogiri
    # @return [Array] The number of found results
    def harvest(pattern, html, arr)
      file = File.open(html)
      doc = Nokogiri::HTML(file)
      doc.xpath(pattern).each do |node|
        if pattern == '//a'
          arr << node.text
        elsif pattern == '//img' and arr.include?(node.to_s)
        elsif pattern == '//img'
          arr << node.to_s
        elsif pattern == '//html'
          arr << node
        end
      end
      arr
    end

    # Count the elements
    #
    # @param arr [Array] An array with all the found html parts.
    # @return [Integer] The number of uniq results in the given array.
    def output_count(arr)
      arr.uniq.count # remove duplicates with uniq
    end

    # Traverse the dir after the pattern and return the number of occurences in the pages
    #
    # @param pattern [String] The xpath regular for Nokogiri expressions after which the HTML is grabbed.
    # @param arr [Array] array to save the results.
    # @param dir [String] The main directory in which the search should be performed.
    # @return [Integer] The number of found results.
    def perform_global_search(pattern, arr, dir)
      traverse(pattern, arr, dir)
      output_count(arr)
    end

    # Traverse the jekyll directory and get the information about a specific pattern
    #
    # @param pattern [String] The xpath regular for Nokogiri expressions after which the HTML is grabbed.
    # @param arr [Array] array to save the results.
    # @param dir [String] The directory in which the html files are stored.
    def traverse(pattern, arr, dir)
      Dir.glob(dir+"/**/*") do |file|
        next if file == '.' or file == '..' or file.include?("html~")
        if file.match(/(.*).html/)
          harvest(pattern, file, arr)
        end
      end
    end

    # Write in the file the text
    #
    # @param file [String] The path to the config file
    # @param text [String] Is a multiline string of text
    # @return [nil]
    def write_config(file, text)
      File.open(file, 'w') do |file|
        file.puts text
        file.close
      end
    end

    # Check the existence of given directory and config
    #
    # @param dir [String] The directory of the files.
    # @param config [String] The path to the config file.
    def check_directory_and_config_file(dir = '', config= '')

      if !Dir.exist? dir or !File.exist? config
        raise "Can't find the _config.yml or the _site directory! Please create these files it!"
      end
    end
  end
end

