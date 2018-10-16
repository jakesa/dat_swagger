require 'bundler'

helper = Bundler::GemHelper.new

task :test, :file do |tsk, args|
  if args
    sh("rspec ./spec/#{args[:file]}")
  else
    sh('rspec ./spec')
  end
end

task :build do
  helper.gemspec.version = DAT::Version.to_s
  helper.build_gem
end

task :bump,[:segment] do |tsk, args|
  case args[:segment].to_sym
  when :major
    DAT::Version.increment_major
  when :minor
    DAT::Version.increment_minor
  when :patch
    DAT::Version.increment_patch
  end unless args.empty? || args[:segment].nil?
  puts DAT::Version.to_s
end

task :set_version, :version do |tsk, v|
  version = v[:version].split('.')
  DAT::Version.set_version major: version[0], minor: version[1], patch: version[2]
  puts DAT::Version.to_s
end

task :deploy do
  path = File.expand_path(File.join(__dir__,"./pkg/dat_jwt-#{DAT::Version.to_s}.gem"))
  if File.exists? path
    sh "gem inabox -g http://10.36.77.177:9292 #{path}"
  else
    raise RuntimeError, 'No gem file found.'
  end
end

task :gem_version do
  puts DAT::Version.to_s
end