module ApplicationHelper
  def extract_tracker link
    return unless link
    uri = URI(link)
    if uri.path =~ /\/.+\/\+.+\/\d+/ and uri.host = "bugs.launchpad.net"
      "Launchpad:#{uri.path.split("/")[1]}##{uri.path.split("/")[3]}"
    elsif uri.path =~ "https:\/\/github.com\/.+\/.+\/(issues|pull)\/\d+"
      parts = uri.path.split("/")
      "GitHub:#{parts[3]}/#{parts[4]}##{parts[6]}"
    else
      link
    end
  end
  def gravatar_url(user, size = 48)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
