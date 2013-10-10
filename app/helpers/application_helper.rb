module ApplicationHelper
  def extract_tracker link
    return unless link
    uri = URI(link)
    if uri.path =~ /\/.+\/\+.+\/\d+/ and uri.host = "bugs.launchpad.net"
      "#{uri.path.split("/")[1]}##{uri.path.split("/")[3]}"
    else
      link
    end
  end
end
