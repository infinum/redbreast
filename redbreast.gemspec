lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redbreast/version'

Gem::Specification.new do |spec|
  spec.name = 'redbreast'
  spec.version = Redbreast::VERSION
  spec.authors = ['Maroje']
  spec.email = ['maroje.marcelic@infinum.com']

  spec.summary = 'A CLI for safe and strongly typed resources'
  spec.homepage = 'https://github.com/infinum/redbreast'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.77'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'commander'
  spec.add_dependency 'tty-prompt'
  spec.add_dependency 'xcodeproj'
end
