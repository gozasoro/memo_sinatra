# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './note'

enable :method_override

get '/' do
  @notes = Note.list
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  Note.new(params[:title], params[:text]).write
  redirect to('/')
end

get '/notes/:filename' do
  @filename = params[:filename]
  @content = Note.content(params[:filename])
  erb :notes
end

patch '/notes/:filename' do
  Note.rewrite(params[:filename], params[:title], params[:text])
  redirect to('/')
end

delete '/notes/:filename' do
  Note.delete(params[:filename])
  redirect to('/')
end
