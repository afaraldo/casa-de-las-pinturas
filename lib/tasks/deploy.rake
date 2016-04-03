DEPLOY_DATA = {test: {app_name: 'casa-de-las-pinturas-test', branch: 'development'},
               prod: {app_name: 'casa-de-las-pinturas', branch: 'master'}}

namespace :deploy do
  desc "Desplegar a heroku"
  [:test,:prod].each do |app|
    task app  do
      git_rev = `git rev-parse --default #{DEPLOY_DATA[app][:branch]} --short=7`

      puts "Desplegando revision #{git_rev.strip} a #{app}"
      sh "git push heroku-#{app} #{DEPLOY_DATA[app][:branch]}:master"

      puts "Configurando la revision"
      run_heroku_command("config:set APP_REVISION=#{git_rev.strip}", DEPLOY_DATA[app][:app_name])

      puts "Corriendo las migraciones"
      run_heroku_command("run rake db:migrate", DEPLOY_DATA[app][:app_name])
    end
  end
end

def run_heroku_command(cmd, app_name)
  Bundler.with_clean_env do
    sh build_heroku_command(cmd, app_name)
  end
end

def build_heroku_command(cmd, app_name)
  "heroku #{cmd} --app #{app_name}"
end