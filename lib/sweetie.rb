require "nokogiri"

class Sweetie

	@@config = "../_config.yml"
	@@dir    = "_site"

	def self.change_config
		file = File.open(@@config)
		text = ""
		while line = file.gets
			if line.match(/build:/)
				text << "build: #{build_time}\n"
			elsif line.match(/pages:/)
				text << "pages: #{count_html_pages(@@dir)}\n"
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

	def self.count_link_of_one_page(page)
		links = []
		links = harvest('//a', page, links, 'a')
		output_count(links)
	end

	def self.count_images_of_one_page(page)
		images = []
		images = harvest('//img', page, images, 'img')
		output_count(images)
	end

	def self.count_html_pages(dir)
		pages = []
		traverse('//html', pages, 'html', dir)
		output_count(pages)
	end

	def self.count_all_links(dir)
		links = []
		traverse('//a', links, 'a', dir)
		output_count(links)
	end

	def self.count_all_images(dir)
		images = []
		traverse('//img', images, 'img', dir)
		output_count(images)
	end

	def self.build_time
		time = Time.now
		"#{time.month}-#{time.day}-#{time.year}"
	end

	def self.traverse(pattern, ar, type, dir)
		Dir.glob(dir+"/**/*") do |file|
			next if file == '.' or file == '..' or file.include?("html~")
			if file.match(/(.*).html/)
				harvest(pattern, file, ar, type)
			end
		end
	end

	def self.harvest(pattern, html, ar, type)
		file = File.open(html)
		doc = Nokogiri::HTML(file)
		doc.xpath(pattern).each do |node|
			if type == "a"
				ar << node.text
			elsif type == "img" and ar.include?(node.to_s)
			elsif type == "img"
				ar << node.to_s
			elsif type == "html"
				ar << node
			else
			end
		end
		ar
	end

	def self.output_count(file)
		file.uniq.count
	end
end

