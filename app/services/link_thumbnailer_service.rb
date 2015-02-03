class LinkThumbnailerService
  
  attr_accessor :post
  
  def initialize(post)
    self.post = post
  end
  
  def perform
    begin
      if url_attributes.images.any? && valid_image_url(url_attributes)
        post.update_attribute(:url, url_attributes.images.first.src.to_s)
      end
    rescue =>e
      Rails.logger.warn("Couldn't parse OG data for post #{post.id}")
    end    
  end
  
  private
  
  def post_url
    url_with_protocol(post.url.to_s)
  end 
  
  #prepend http:// to url if it is missing
  def url_with_protocol(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end
  
  def url_attributes
    LinkThumbnailer.generate(url, attributes: [:images], 
      http_timeout: 2, image_limit: 1, image_stats: false)    
  end
  
  #return false if url starts with a / character
  #I want to ignore these urls as it results in a localhost lookup
  #
  #example: /images/sample.jpg would be false
  def valid_image_url(url)
    !url.images.first.src.to_s.starts_with?('/')
  end
  
  
end