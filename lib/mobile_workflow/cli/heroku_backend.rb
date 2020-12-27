module MobileWorkflow::Cli
  class HerokuBackend
    def initialize(app_name:)
      @heroku_app_name = app_name.gsub("_", "-")
    end
  
    def create
      heroku_command "heroku create #{@heroku_app_name}"
      heroku_command "git push --set-upstream heroku master"
    end
  
    def configure_activestorage
      heroku_command "heroku buildpacks:add -i 1 https://github.com/heroku/heroku-buildpack-activestorage-preview --app #{@heroku_app_name}"
      heroku_command "heroku labs:enable runtime-dyno-metadata --app #{@heroku_app_name}" # Gives access to heroku variables which can be used to construct URLs
    
      # Force recompile after buildpacks change
      heroku_command "git commit --allow-empty -m 'empty commit'"
      deploy    
    end
  
    def deploy
      heroku_command "git push"
    end
  
    def sync_dotenv
      env = File.read(".env").split.join(" ")
      puts "Setting env: #{env}"
      heroku_command "heroku config:set #{env} --app #{@heroku_app_name}"
    end
  
    def destroy
      heroku_command "heroku destroy #{@heroku_app_name} --confirm #{@heroku_app_name}"
    end
  
    def notifications_endpoint
      "https://#{@heroku_app_name}.herokuapp.com/sns_notifications"
    end
  
    private
    def heroku_command(command)
      puts "Running: #{command}"
      output = `#{command}`
      puts "Output: #{output}"
      return output
    end
  end
end