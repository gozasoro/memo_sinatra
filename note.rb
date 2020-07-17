# frozen_string_literal: true

class Note
  class << self
    def list
      array = []
      Dir.glob('notes/*').sort_by { |f| File.birthtime(f) }.each do |path|
        title = ''
        File.open(path) { |f| title = f.gets }
        array.push << {
          title: title,
          filename: File.basename(path)
        }
      end
      array
    end

    def content(filename)
      hash = {}
      File.open("notes/#{filename}") do |f|
        lines = f.readlines
        hash[:title] = lines.shift
        hash[:text] =  lines.join('')
      end
      hash
    end

    def rewrite(filename, title, text)
      path = "notes/#{filename}"
      File.open(path, 'w') do |f|
        f.puts title == '' ? 'no title' : title
        f.puts text
      end
    end

    def delete(filename)
      File.delete("notes/#{filename}")
    end
  end

  def initialize(title, text)
    @title = title == '' ? 'no title' : title
    @text = text
  end

  def write
    path = "notes/#{Time.now.to_i}.txt"
    File.open(path, 'w') do |f|
      f.puts @title
      f.puts @text
    end
  end
end
