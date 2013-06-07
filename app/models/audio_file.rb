class AudioFile < ActiveRecord::Base
  attr_accessible :size, :media_type, :url, :episode, :episode_id

  belongs_to :episode

  validates_presence_of :media_type, :url, :episode_id

  before_save :update_size, if: :url_changed?

  private

  def update_size
    if url.present?
      begin
        fetch_size
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        self.size = nil
      end
    end
  end

  def fetch_size
    uri = URI.parse(self.url)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request_head(uri.path)
    end
    if response.code == "200"
      self.size = response["content-length"].to_i
    else
      self.size = nil
    end
  end
end
