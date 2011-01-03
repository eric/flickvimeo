require "net/http"
require "uri"
require 'nokogiri'

module FlickVimeo
  class Video
    attr_accessor :clip_id, :url

    def initialize(id)
      @clip_id = vimeo_id(id)
      @url     = "http://vimeo.com/moogaloop/load/clip:#{@clip_id}/local/"
      @codec = 'h264'
    end
    
    def video_redirect_url
      "http://player.vimeo.com/play_redirect?quality=#{quality}&codecs=#{@codec}&clip_id=#{clip_id}&time=#{timestamp}&sig=#{signature}&type=html5_desktop_local"
    end
    
    def video_file_url
      @video_file_url ||= begin
        response = http_request(video_redirect_url)
        response['Location']
      end
    end
    
    def timestamp
      config.search('timestamp').text
    end
    
    def signature
      config.search('request_signature').text
    end
    
    def quality
      config.search('video isHD').text == '1' ? 'hd' : 'sd'
    end
    
    def config
      @config ||= begin
        response = http_request(@url)
        Nokogiri::XML.parse(response.body)
      end
    end
    
    def vimeo_id(id)
      case id.to_s
      when %r{^http://.*vimeo.com.*[#/](\d+)}
        $1
      when /^\d+$/
        id
      else
        raise "Unknown id format: #{id}"
      end
    end

    def http_request(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Get.new(uri.request_uri)
      request["User-Agent"] = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-us) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4"

      response = http.request(request)
    end
  end
end