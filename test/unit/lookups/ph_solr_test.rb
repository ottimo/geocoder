# encoding: utf-8
require 'test_helper'

class PhSolrTest < GeocoderTestCase
  def setup
    Geocoder.configure(lookup: :ph_solr)
  end

  def test_ph_solr_result_components
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "Manhattan", result.address_components_of_type(:sublocality).first['long_name']
  end

  def test_ph_solr_query_url
    query = Geocoder::Query.new("Madison Square Garden, New York, NY")
    assert_equal "http://127.0.0.1:8080/solrservice/rest/suggestservice?address=Madison+Square+Garden%2C+New+York%2C+NY", query.url
  end

  def test_ph_solr_query_url_with_custom_host
    Geocoder.configure(ph_solr: {host: 'NOT_AN_ACTUAL_HOST'})
    query = Geocoder::Query.new("Madison Square Garden, New York, NY")
    assert_equal "http://NOT_AN_ACTUAL_HOST:8080/solrservice/rest/suggestservice?address=Madison+Square+Garden%2C+New+York%2C+NY", query.url
  end

end
