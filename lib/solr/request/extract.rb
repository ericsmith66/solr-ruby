require 'mime/types'

class Solr::Request::Extract < Solr::Request::Update
  
  def initialize(document_id,file_path)
    self.document_id = document_id
    self.file_path = file_path
  end

  def response_format
    :xml
  end

  def handler
    'update/extract' + uri_params
  end
  
  def file_name
    File.basename(file_path).gsub(/ /, "_")
  end
  
  def is_plain_text?
    file_name.ends_with?(".txt")
  end
  
  def uri_params
    if is_plain_text?
      "?ext.idx.attr=true\&ext.stream.type=text/plain\&ext.def.fl=text\&ext.literal.id=Attachment:#{document_id}"
    else
      "?ext.idx.attr=true\&ext.def.fl=text\&ext.literal.id=Attachment:#{document_id}"
    end
  end
  
  attr_accessor :document_id, :file_path
  
  def to_s
    File.read(file_path)
  end
  
  def content_type
    MIME::Types.type_for(file_name).first.content_type
  end
end
