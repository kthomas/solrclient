
require 'solrclient/httpclient'

#
# Solr client
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
    # given params hash must contain the unique
    # identifier for the document as params[:id]
    # 
    #
    def update params = {}
      if delete(params[:id])
        response = index(params)
        yield JSON.parse(response.body) if block_given? && response.code == 200.to_s
        response
      end
    end
    
    # 
    # Remove a single document from the Solr
    # collection given its unique identifier
    # 
    #
    def delete document_id
      uri = uri_by_appending('update')
      http_client.post(uri + '?wt=json', {
        delete: {
          id: document_id
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
