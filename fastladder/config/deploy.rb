set :application, 'fastladder'

set :repo_url, 'https://github.com/fastladder/fastladder'
set :scm, :git
set :branch, 'master'

set :deploy_to, '/home/fastladder/fastladder'
set :log_level, :debug

set :upload_files, %w[
  config/application.yml
  config/unicorn.rb
  Gemfile.fastladder
  Gemfile.fastladder.lock
]
set :linked_files, fetch(:upload_files) + %w[config/database.yml config/initializers/secret_token.rb]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle]
set :keep_releases, 5

set :default_env, {
  'BUNDLE_GEMFILE' => 'Gemfile.fastladder',
}

# capistrano-bundler
set :bundle_flags, '--deployment -j4'
set :bundle_binstubs, nil

set :unicorn_pid, 'log/unicorn.pid'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      path = current_path.join(fetch(:unicorn_pid))
      if test("[[ -r #{path} ]]")
        execute :kill, "-HUP `cat #{path}`"
      end
    end
  end
  after :publishing, :restart

  desc 'Upload config'
  task :upload do
    on roles(:app) do
      fetch(:upload_files).each do |path|
        if File.readable?(path)
          upload!(path, shared_path.join(path))
        end
      end
    end
  end
  before :updating, :upload
end
