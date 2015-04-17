# More information about the Data Science Toolkit can be found at:
# http://www.datasciencetoolkit.org/. The provided APIs mimic the
# Google geocoding api.

require 'geocoder/lookups/google'
require 'geocoder/results/ph_solr'
require "pry"

module Geocoder::Lookup
  class PhSolr < Google

    def name
      "Phoops Solr"
    end

    def results(query)
      Geocoder.log(:debug, "Geocoder: result #{query.to_s}")
      return [] unless doc = fetch_data(query)
      return doc['results'] if doc['status'].nil?

      case doc['status']; when "OK" # OK status implies >0 results
        return doc['results']
      when "OVER_QUERY_LIMIT"
        raise_error(Geocoder::OverQueryLimitError) ||
          Geocoder.log(:warn, "Geocoding API error: over query limit.")
      when "REQUEST_DENIED"
        raise_error(Geocoder::RequestDenied) ||
          Geocoder.log(:warn, "Geocoding API error: request denied.")
      when "INVALID_REQUEST"
        raise_error(Geocoder::InvalidRequest) ||
          Geocoder.log(:warn, "Geocoding API error: invalid request.")
      end
      return []
    end

    def query_url(query)
      host = configuration[:host] || "127.0.0.1"
      "#{protocol}://#{host}:8080/solrservice/rest/suggestservice?" + url_query_string(query)
    end

    def query_url_solr_params(query)
      params = {
        (query.reverse_geocode? ? :latlng : :address) => query.sanitized_text,
        #:sensor => "false",
        #:language => (query.language || configuration.language)
      }
      unless (bounds = query.options[:bounds]).nil?
        params[:bounds] = bounds.map{ |point| "%f,%f" % point }.join('|')
      end
      unless (region = query.options[:region]).nil?
        params[:region] = region
      end
      unless (components = query.options[:components]).nil?
        params[:components] = components.is_a?(Array) ? components.join("|") : components
      end
      params

    end

    def query_url_params(query)
      query_url_solr_params(query)
      #.merge(
      #  :key => configuration.api_key
      #).merge(super)
    end

  end
end
