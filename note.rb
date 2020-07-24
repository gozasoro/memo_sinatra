# frozen_string_literal: true

require 'pg'

class Note
  class << self
    def list
      array = []
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.exec('select * from notes').each do |row|
        array << {
          filename: row['id'],
          title: row['title']
        }
      end
      conn&.close
      array
    end

    def content(filename)
      hash = {}
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.prepare('content', 'select * from notes where id = $1')
      conn.exec_prepared('content', [filename]) do |result|
        hash[:title] = result[0]['title']
        hash[:text] = result[0]['text']
      end
      conn&.close
      hash
    end

    def rewrite(filename, title, text)
      title == '' ? 'no title' : title
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.prepare('rewrite', 'update notes set title = $1, text = $2 where id = $3')
      conn.exec_prepared('rewrite', [title, text, filename])
      conn&.close
    end

    def delete(filename)
      conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
      conn.prepare('delete', 'delete from notes where id = $1')
      conn.exec_prepared('delete', [filename])
      conn&.close
    end
  end

  def initialize(title, text)
    @title = title == '' ? 'no title' : title
    @text = text
  end

  def write
    conn = PG.connect(host: 'localhost', user: 'postgres', password: 'password', dbname: 'memo_sinatra')
    conn.prepare('write', 'insert into notes (title, text) values ($1, $2);')
    conn.exec_prepared('write', [@title, @text])
    conn&.close
  end
end
