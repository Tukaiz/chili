module ChiliDoc

  class GetDocVals
    include HappyMapper
    tag 'item'

    attribute :name, String
    attribute :value, String
    attribute :type, String
  end

  class FileInfo
    include HappyMapper
    tag 'fileInfo'

    attribute :indexed_at, DateTime, :tag => 'fileIndexed'
  end


  class DocumentResource
    include HappyMapper
    tag 'item'

    attribute :name, String
    attribute :doc_id, String, :tag => 'id'
    attribute :icon_url, String, :tag => 'iconURL'
    attribute :is_folder, Boolean, :tag => 'isFolder'
    has_many :file_info, ChiliDoc::FileInfo
  end



  class AlternateLayout
    include HappyMapper
    tag 'item'

    attribute :height, Float
    attribute :width, Float
    attribute :layout_id, String, :tag => 'id'
    attribute :name, String
  end

  class DocumentInfo
    include HappyMapper
    tag 'documentInfo'

    attribute :name, String
    attribute :doc_id, String, :tag => 'id'
    attribute :path, String
    attribute :height, Float
    attribute :width, Float
    attribute :zoom, Float
    attribute :initial_layout_id, String, :tag => 'initialLayout'
    attribute :initial_layout_name, String, :tag => 'initialLayoutName'

    has_many  :alternate_layouts, ChiliDoc::AlternateLayout
  end



end