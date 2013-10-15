# 
# Http client that speaks JSON
# 
# Wraps functionality provided by the
# persistent_http gem for connection pooling
#
class HttpClient
  require 'json'
  require 'persistent_http'

  class << self
    
    def uri_encode str
      URI.escape(str, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def build_query_string params
      query_string = nil
      if params.length > 0
        query_string = '?'
        params.each_pair do |name, value|
          query_string += uri_encode(name.to_s) + '=' + (value.nil? ? '' : uri_encode(value.to_s)) + '&'
        end
        query_string = query_string[0..query_string.length - 2]
      end
      query_string
    end
    
  end

  def initialize hostname, port, uri = nil, use_ssl = false
    base_url = 'http' + (use_ssl ? 's://' : '://') + hostname + ':' + port.to_s + (uri.nil? ? '' : '/' + uri.gsub(/(^\/+)(.*)/, '\2'))
    @connection_pool = PersistentHTTP.new(
        name: 'SolrClient-' + Time.now.to_i.to_s,
        pool_size: 10,
        pool_timeout: 30,
        url: base_url
    )
  end

  def get uri, params = {}
    query_string = HttpClient.build_query_string(params)
    request = Net::HTTP::Get::new(uri + (query_string.nil? ? '' : query_string))
    @connection_pool.request(request)
  end

  def post uri, params
    request = Net::HTTP::Post::new(uri)
    request.body = params.to_json
    request.add_field('content-type', 'application/json')
    @connection_pool.request(request)
  end

  def put uri, params
    request = Net::HTTP::Put::new(uri)
    request.body = params.to_json
    request.add_field('content-type', 'application/json')
    @connection_pool.request(request)
  end

  def delete uri
    request = Net::HTTP::Delete::new(uri)
    @connection_pool.request(request)
  end

end
