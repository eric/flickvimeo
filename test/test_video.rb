require File.expand_path('../helper', __FILE__)
require 'pp'

class TestBasic < Test::Unit::TestCase
  def setup
    @video = FlickVimeo::Video.new(18017106)
  end
  
  def test_format
    assert_equal 'hd', @video.best_quality
  end
  
  def test_clip_id
    assert_equal 18017106, @video.clip_id
  end
  
  def test_video_file_url
    pp @video.config
    puts @video.video_file_url
    assert_not_nil @video.video_file_url
  end
end