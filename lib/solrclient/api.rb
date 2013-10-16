require 'rubygems'
require 'bundler/setup'
require 'solrclient'

  # client API entry point for solr and zookeeper stuff
  #
  # cheapest integration:
  #   api_client = SolrClientApi.new('solr.example.com', 'recommendations')
  #   api_client.solr_client.index({id: 'bi-dealership-id', type: 'dealership', make_s: 'Benz', comment_s: 'test 123'})
  #   api_client:solr_client.delete('id:bi-dealership-id') # solr query syntax - id field is not a unique constraint in solrconfig.xml
  #   api_client.truncate_index!
  #
  # see lib/solrclient.rb for a more advanced usage

class SolrClientApi
  
  class << self;  end
  
  def initialize hostname, collection
    @hostname = hostname
    @collection = collection
  end
  
  # index something that looks like: {id: 'bi-dealership-id', type: 'dealership', comment_s: 'test 123'}
  def index document
    solr_client.index(document)
  end
  
  # delete a document by id
  def delete id
    solr_client.delete('id:' + id)
  end

  def truncate_index!
    solr_client.delete('*:*')
  end
  
  private
  
  def solr_client
    @solr_client ||= begin
      @solr_client = SolrClient::Collection.new(@hostname, @collection)
    end
  end
  
end
