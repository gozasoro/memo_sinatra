# frozen_string_literal: true

require 'pg'

class Note
  class << self
    def list
      array = []
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.exec('select * from notes;').each do |row|
        array.push << {
          title: row['title'],
          filename: row['id']
        }
      end
      conn&.close
      array
    end

    def content(filename)
      hash = {}
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.exec("select * from notes where id = #{filename};") do |result|
        hash[:title] = result[0]['title']
        hash[:text] = result[0]['text']
      end
      conn&.close
      hash
    end

    def rewrite(filename, title, text)
      title == '' ? 'no title' : title
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.exec("update notes set title = '#{title}', text = '#{text}' where id = #{filename}")
      conn&.close
    end

    def delete(filename)
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.exec("delete from notes where id = #{filename}")
      conn&.close
    end
  end

  def initialize(title, text)
    @title = title == '' ? 'no title' : title
    @text = text
  end

  def write
    conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
    conn.exec("insert into notes (title, text) values ('#{@title}', '#{@text}');")
    conn&.close
  end
end
