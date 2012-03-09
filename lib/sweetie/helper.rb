module Sweetie

  module Helper

    # Traverse the page after the pattern and return the number of occurences on it
    # @param [pattern] need for nokogiri to parse the html page
    # @param [array] array to save the results
    # @param [page] a single page which will be taken for the search
    def perform_search_for_single_page(pattern, array, page)
      harvest(pattern, page, array)
      output_count(array)
    end

    # Traverse the dir after the pattern and return the number of occurences in the pages
    # @param [pattern] need for nokogiri to parse the html page
    # @param [array] array to save the results
    # @param [dir] the main directory in which the by jekyll generated files are stored
    def perform_global_search(pattern, array, dir)
      traverse(pattern, array, dir)
      output_count(array)
    end

    # Traverse the jekyll directory and get the information about a specific pattern
    # @param [pattern] is a string for nokogiri after which the html pages should be parsed
    # @param [ar] is an empty Array which is used by the harvest method
    # @param [dir] the directory in which the html files are stored
    def traverse(pattern, ar, dir)
      Dir.glob(dir+"/**/*") do |file|
        next if file == '.' or file == '..' or file.include?("html~")
        if file.match(/(.*).html/)
          harvest(pattern, file, ar)
        end
      end
    end

    # Traverse each html page and gather information about the specified html element
    # @param [pattern] important for nokogiri
    # @param [html] the path for the html file
    # @param [ar] and array which stores all the findings produces by nokogiri
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
    # @param [ar] is an array with all the found html parts
    def output_count(ar)
      ar.uniq.count # remove duplicates with uniq
    end

    # Write in the file the text
    # @param [file] is the _config.yml file of the jekyll project
    # @param [text] is a multiline string which will be written in the file
    def write_config(file, text)
      File.open(file, 'w') do |file|
        file.puts text
        file.close
      end
    end

    # Check the existence of needed files for sweetie
    # @param [config] the _config.yml file
    # @param [dir] the directory of the generated jekyll page
    def check_config_and_directory_file(config, dir)
      if !File.exist? @@config or !Dir.exist? @@dir
        raise "Can't find the _config.yml or the _site directory! Please create these files it!"
      end
    end

  end

end

