$:.push File.expand_path('../lib', __FILE__)

require 'solrclient/version'

Gem::Specification.new do |s|
  s.name        = 'solrclient'
  s.version     = SolrClient::VERSION
  s.authors     = ['Kyle Thomas']
  s.email       = ['k.thomas@unmarkedconsulting.com']
  s.homepage    = 'https://github.com/kthomas/solrclient'
  s.summary     = 'Solr HTTP client'
  s.description = 'Minimal HTTP solr client that speaks JSON and uses connection pooling'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']

  s.add_development_dependency 'mocha'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'spork'
end
