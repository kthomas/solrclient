require 'spec_helper'

describe SolrClient do
  
  describe SolrClient::Collection do
  
    let(:collection) { SolrClient::Collection.new 'example.com', 'collection1', 8080 }

    context '#query' do

      it 'should invoke an onsuccess block with the JSON response if one is provided' do
        HttpClient.any_instance.stubs(:get).returns(OpenStruct.new(code: '200', body: '{}'))
        expect { |onsuccess| collection.query({}, &onsuccess) }.to yield_with_args({})
      end
      
      # it 'should invoke the Yahoo! geocoding API if a zipcode is provided' do
      #   HttpClient.any_instance.stubs(:get).with('/select').returns(OpenStruct.new(code: '200', body: '{}'))
      #   HttpClient.any_instance.stubs(:get).with('/v1/places.q(\'30328\')').returns(OpenStruct.new(code: '200', body: '{latitude: 33.93457, longitude: -84.395668}'))
      #   
      #   expect { |onsuccess| collection.query({zip: '30328'}, &onsuccess) }.to yield_with_args({})
      # end

    end

    context '#index' do

      it 'should invoke an onsuccess block with the JSON response if one is provided' do
        HttpClient.any_instance.stubs(:post).returns(OpenStruct.new(code: '200', body: '{}'))
        expect { |onsuccess| collection.index({}, &onsuccess) }.to yield_with_args({})
      end

    end
  
    context '#update' do

      it 'should invoke an onsuccess block with the JSON response if one is provided' do
        HttpClient.any_instance.stubs(:post).returns(OpenStruct.new(code: '200', body: '{}'))
        expect { |onsuccess| collection.update({}, &onsuccess) }.to yield_with_args({})
      end

    end
  
    context '#delete' do

      it 'should return true if the document was successfully deleted' do
        HttpClient.any_instance.stubs(:post).returns(OpenStruct.new(code: '200', body: '{}'))
        collection.delete({id: '123'}).should be_true
      end

    end

  end

end
