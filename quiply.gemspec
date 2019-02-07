
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quiply/version'

Gem::Specification.new do |spec|
  spec.name          = 'quiply'
  spec.version       = Quiply::VERSION
  spec.authors       = ['stephan.com']
  spec.email         = ['stephan@stephan.com']

  spec.summary       = 'a coding challenge for quip'
  spec.description   = 'Group users into week long cohorts based on the user\'s signup date'
  spec.homepage      = 'https://github.com/stephancom/quiply'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://gems.stephan.com/'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/stephancom/quiply'
    spec.metadata['changelog_uri'] = 'https://github.com/stephancom/quiply/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.2.2'
  spec.add_dependency 'groupdate', '~> 4.1.0'
  spec.add_dependency 'methadone', '~> 2.0.0'
  spec.add_dependency 'ruby-progressbar', '~> 1.10.0'
  spec.add_dependency 'smarter_csv', '~> 1.2.6'
  spec.add_dependency 'sqlite3', '~> 1.3.6'
  spec.add_dependency 'terminal-table', '~> 1.8.0'

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'database_cleaner', '~> 1.7.0'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'pry-coolline', '~> 0.2.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.1.0'
  spec.add_development_dependency 'rspec-command', '~> 1.0.3'
  spec.add_development_dependency 'rubocop', '~> 0.60.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.4.0'
end
