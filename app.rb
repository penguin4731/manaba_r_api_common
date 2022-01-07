require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require 'net/http'
require "json"
require 'uri'
require 'dotenv'
require './manaba.rb'

Dotenv.load

not_found do
  status 404
  return json({ status: 'error', code: 404, stacktrace: Thread.current.backtrace })
end

# ==========================================
# タスクを取得
# ==========================================
get '/tasks' do
  manaba = ManabaManager.new
  tasks = []

  manaba.loginManaba
  tasks.push(manaba.getTasks(0))
  tasks.push(manaba.getTasks(1))
  tasks.push(manaba.getTasks(2))
  manaba.quit
  tasks = tasks.flatten

  status 200
  return json({ status: 'success', code: 200, tasks: tasks })
end
