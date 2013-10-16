require 'spec_helper'

describe HttpClient do

  let(:hostname) { 'ec2-54-242-203-240.compute-1.amazonaws.com' }
  let(:port)     { 8983 }
  let(:use_ssl)  { false }

  let(:httpclient) { HttpClient.new hostname, port, use_ssl }

  context '#get' do

    it 'should issue a GET request using the connection pool' do
      Net::HTTP::Get.expects(:new).once
      PersistentHTTP.any_instance.expects(:request).once

      httpclient.get('/collection1/select', {
          q: '*:*', wt: 'json', indent: true
      })
    end

  end

  context '#post' do

    it 'should issue a POST request using the connection pool' do
      Net::HTTP::Post.any_instance.expects(:body=).once
      PersistentHTTP.any_instance.expects(:request).once

      httpclient.post('/collection1/select', {})
    end

  end

  context '#put' do

    it 'should issue a PUT request using the connection pool' do
      Net::HTTP::Put.any_instance.expects(:body=).once
      PersistentHTTP.any_instance.expects(:request).once

      httpclient.put('/collection1/select', {})
    end

  end

  context '#delete' do

    it 'should issue a DELETE request using the connection pool' do
      Net::HTTP::Delete.expects(:new).once
      PersistentHTTP.any_instance.expects(:request).once

      httpclient.delete('/collection1/select')
    end

  end

end
