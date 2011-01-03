require "net/http"
require "uri"
require 'yajl'

module FlickVimeo
  class Video
    def initialize(id)
      @id  = id
      @url = vimeo_url(id)
      @codec = 'h264'
    end
    
    def video_redirect_url
      "http://player.vimeo.com/play_redirect?quality=#{best_quality}&codecs=#{@codec}&clip_id=#{clip_id}&time=#{timestamp}&sig=#{signature}&type=html5_desktop_local"
    end
    
    def video_file_url
      @video_file_url ||= begin
        response = http_request(video_redirect_url)
        response['Location']
      end
    end
    
    def timestamp
      config['config']['request']['timestamp']
    end
    
    def signature
      config['config']['request']['signature']
    end
    
    def clip_id
      config['config']['video']['id']
    end
    
    def best_quality
      config['config']['video']['files'][@codec].first
    end
    
    def config
      @config ||= begin
        response = http_request(@url)
        
        if m = response.body.match(/clip\d+_\d+ = (.*)?;Player.checkRatio/)
          # Cleanup javascript to be valid JSON
          json = m[1].gsub(/([\{\[,]\s*)([a-zA-Z_]+):/) { %{#{$1}"#{$2}":} }
          json = json.gsub(/(:\s*)'(.*?)'/, '\1"\2"')
          
          Yajl::Parser.parse(json)
        end
      end
    end
    
    def vimeo_url(id)
      case id.to_s
      when %r{^http://.*vimeo.com.*[#/](\d+)}
        "http://player.vimeo.com/video/#{$1}"
      when /^\d+$/
        "http://player.vimeo.com/video/#{id}"
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