module Util
  def extract_filename(url)
    if url =~ /.+\/([a-zA-Z0-9._-]+)$/
      $1
    else
      ''
    end
  end
end
