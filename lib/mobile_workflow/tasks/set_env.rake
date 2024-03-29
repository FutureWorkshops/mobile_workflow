# frozen_string_literal: true

require 'json'

def each_step(json, type, &block)
  json['workflows'].map { |w| w['steps'].select { |s| s['type'] == type.to_s } }.flatten.each(&block)
end

def replace_oauth(app_json)
  client_id = ENV['CLIENT_ID']
  client_secret = ENV['CLIENT_SECRET']
  redirect_scheme = ENV['SCHEME']

  each_step(app_json, :networkOAuth2) do |step|
    step['items'].each do |item|
      next unless item['oAuth2ClientId']

      item['oAuth2ClientId'] = client_id
      item['oAuth2ClientSecret'] = client_secret
      item['oAuth2RedirectScheme'] = redirect_scheme
    end
  end
end

def replace_servers(app_json)
  server_url = ENV['SERVER_URL']
  base_url = ENV['PREVIOUS_SERVER_URL']

  app_json['servers'].each do |server|
    server['url'] = server_url
  end

  each_step(app_json, :display) do |step|
    step['items'].each do |item|
      %w[appleSystemURL androidDeepLink].each { |key| item[key] = item[key].gsub(base_url, server_url) }
    end
  end
end

def env_set(_path)
  app_json = JSON.parse(File.read(app_json_path))
  replace_oauth(app_json)
  replace_servers(app_json)
  File.write(app_json_path, app_json.to_json)
end

namespace :mw do
  namespace :set_env do
    desc 'Update Android app.json to use new env'
    task android: :environment do
      env_set(File.join('app', 'src', 'main', 'res', 'raw', 'app.json'))
    end

    desc 'Update iOS app.json to use new env'
    task ios: :environment do
      project_name = ENV['PROJECT_NAME']
      env_set(File.join(project_name, project_name, 'Resources', 'app.json'))
    end
  end
end
