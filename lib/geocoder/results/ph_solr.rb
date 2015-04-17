require 'geocoder/results/google'

module Geocoder::Result
  class PhSolr < Google

    def initialize(data)
      super(data)
      @data = recursive_snakecase_keys(@data)
    end

    def recursive_snakecase_keys(h)
      case h
      when Hash
        Hash[
          h.map do |k, v|
            [ snakecase(k), recursive_snakecase_keys(v) ]
          end
        ]
      when Enumerable
        h.map { |v| recursive_snakecase_keys(v) }
      else
        h
      end
    end

    def snakecase(str)
      #gsub(/::/, '/').
      str.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        gsub(/\s/, '_').
        gsub(/__+/, '_').
        downcase
    end

  end
end
