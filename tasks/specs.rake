namespace :specs do

  def with_gemfile gemfile, clean=false, &block
    Bundler.with_clean_env do
      gemfile = File.expand_path(gemfile)
      ENV['BUNDLE_GEMFILE'] = gemfile

      unless File.exist?( "#{gemfile}.lock")
        args = ["--quiet"]
        puts "bundling #{gemfile}"
        `bundle install --gemfile='#{gemfile}' #{args.join(' ')}`
      end

      system "bundle exec '#{yield}'"
    end
  end

  def tracer msg
    puts ""
    puts (0..(msg.length+10)).map { |i| "=" }.join
    puts "     #{msg}"
    puts (0..(msg.length+10)).map { |i| "=" }.join
  end

  desc "run middleman specs with currently stable middleman"
  task :stable do
    tracer "running specs on stable middleman 3.3.x on ruby #{RUBY_VERSION}"
    with_gemfile 'gemfiles/middleman.3.3.gemfile' do
      'rspec spec/' or exit(1)
    end
  end

  desc "run middleman specs with currently stable middleman"
  task :head do
    tracer "running specs on stable middleman 4.0.x on ruby #{RUBY_VERSION}"
    with_gemfile 'gemfiles/middleman.4.0.gemfile' do
      'rspec spec/' or exit(1)
    end
  end

  desc "run middleman specs w/ CI gemfile"
  task :ci do
    puts "command: bundle exec rspec #{File.join ENV['TRAVIS_BUILD_DIR'], 'spec'}/"
    system "bundle exec rspec #{File.join ENV['TRAVIS_BUILD_DIR'], 'spec'}/" or exit(1)
  end

  desc "check for pry statements"
  task :pry_search do
    require 'bundler/setup'

    pry_statements = []
    files = Gem::Specification.find_by_name('middleman-data_source').files.select { |f| f.match(/\.rb$/) }
    files.each do |f|
      open(f) do |f|
        f.each_line.with_index do |line, idx|
          if /binding\.pry/.match(line)
            pry_statements.push "#{f.path}:#{idx}"
          end
        end
      end
    end

    raise "binding.pry found in files\n#{pry_statements.join("\n")}" unless pry_statements.empty?
  end
end

desc "run all specs on ruby #{RUBY_VERSION}"
task :specs do
  if ENV['CI']
    Rake::Task['specs:ci'].invoke
  else
    Rake::Task['specs:stable'].invoke
    Rake::Task['specs:head'].invoke
  end
  Rake::Task['specs:pry_search'].invoke
end
