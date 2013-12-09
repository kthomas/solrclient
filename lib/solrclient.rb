
require 'solrclient/httpclient'

#
# Solr client usage:
#
# index a document:
# response = solr_client.index({id: 'bi-dealership-id', type: 'dealership', comment_s: 'test 123'})
# if response.code == '200'
#     puts 'Indexed document...'
#     # delete that same document:
#     if solr_client.delete('id:bi-dealership-id AND type:dealership') # Solr query syntax
#         puts 'Deleted document with id: bi-dealership-id'
#     else
#         puts 'Failed to delete document with id: bi-dealership-id'
#     end
# end
# 
# # index a document and require it to be written to the index within 5 seconds:
# response = solr_client.index({id: 'bi-dealership-id-2', type: 'dealership', comment_s: 'test 456'}, {commitWithin: 5000})
# if response.code == '200'
#     puts 'Indexed document'
#     if solr_client.delete('id:bi-dealership-id-2 AND type:dealership') # Solr-style query syntax for deleting documents
#         puts 'Deleted document with id: asdfasdfasdf'
#     else
#         puts 'Failed to delete document with id: asdfasdfasdf'
#     end
# end 
# 
#
# TODO: write a method to destroy/cleanup the pooled Http connections
#
module SolrClient
  
  #
  # Solr collection
  #
  #
  class Collection
    
    attr_accessor :collection_name

    def initialize hostname, collection_name, port = 8983, use_ssl = false
      @hostname = hostname
      @collection_name = collection_name
      @port = port
      @use_ssl = use_ssl
      
      # TODO: raise an exception if any of the params are invalid
    end
    
    # 
    # Issue a search query against the Solr collection
    # 
    #
    def query params = {}
      uri = uri_by_appending('select')
      response = http_client.get(uri, params)
      yield JSON.parse(response.body) if response.code == 200.to_s
      response
    end
    
    # 
    # Index a document in the Solr collection
    #
    # params may include any of the following
    # in addition to the "doc":
    #   "boost":1.0
    #   "overwrite":true
    #   "commitWithin":1000 (millis)
    #
    def index document = {}, params = {}
      params[:doc] = document
      uri = uri_by_appending('update')
      response = http_client.post(uri + '?wt=json', {
        add: params
      })
      yield JSON.parse(response.body) if block_given? && response.code == 200.to_s
      response
    end
    
    # 
    # Update a document in the Solr collection;
    # this is a convenience method and provides
    # parity to calling #delete and #index; the
    # given document hash must contain the unique
    # identifier for the document as document[:id]
    # 
    #
    def update document = {}, params = {}
      unless document[:id].nil? || document[:id].match(/^\*/i)
        delete('id:' + document[:id])
      end

      response = index(document, params)
      yield JSON.parse(response.body) if block_given? && response.code == 200.to_s
      response
    end
    
    # 
    # Remove one or more documents from the Solr
    # collection given a valid Solr query string
    # 
    #
    def delete solr_query
      uri = uri_by_appending('update')
      http_client.post(uri + '?wt=json', {
        delete: {
          query: solr_query
        }
      }).code == 200.to_s
    end
    
    private
    
    def http_client
      @http_client ||= begin
        @http_client = HttpClient.new(@hostname, @port, @use_ssl)
      end
    end

    def uri_by_appending path
      '/' + @collection_name + '/' + path.gsub(/(^\/+)(.*)/, '\2')
    end
    
  end

end
