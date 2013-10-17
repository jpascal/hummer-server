module ApplicationHelper
  def extract_tracker link
    return unless link
    uri = URI(link)
    if uri.path =~ /\/.+\/\+.+\/\d+/ and uri.host = "bugs.launchpad.net"
      "Launchpad:#{uri.path.split("/")[1]}##{uri.path.split("/")[3]}"
    elsif uri.path =~ /https\:\/\/github\.com\/[a-zA-Z-]+\/[a-zA-Z-]+\/(pull|issues)\/\d+/
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
  def sortable(column, title = nil)
    title ||= column.to_s.titleize
    if respond_to? "sort_column"
      css_class = column.to_s == sort_column ? "current #{sort_direction}" : nil
      direction = column.to_s == sort_column && sort_direction == "asc" ? "desc" : "asc"
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    else
      title
    end
  end
end
