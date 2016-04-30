require 'rubygems'
require 'json'
require 'sinatra'
require 'gcm'
require 'pstore'

class App < Sinatra::Base

  store = PStore.new('registration_ids')
  gcm_key = ENV['GCM_KEY']

  post '/push' do
    content_type :json
    data = JSON.parse request.body.read

    gcm = GCM.new(gcm_key)
    account_id = data['data']['account_id']
    registration_id = ""
    store.transaction do
      registration_id = store.fetch(account_id, 'default value')
    end
    registration_ids= [registration_id] # an array of one or more client registration tokens
    options = {data: {message: data}}
    response = gcm.send(registration_ids, options)
    puts response[:body]
  end

  put '/token' do
    content_type :json
    data = JSON.parse request.body.read

    store.transaction do
      store[data['account_id']] = data['token']
    end
    '{"success" : true}'
  end
end
