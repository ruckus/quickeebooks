module Logging

  def log(msg)
    ::Quickeebooks.log(msg)
  end

  def log_xml(str)
    unless str and str.empty?
      Nokogiri::XML(str).to_xml
    else
      str
    end
  rescue => e
    e
  end

end
