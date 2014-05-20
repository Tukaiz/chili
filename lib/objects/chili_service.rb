module ChiliService

  class Authentication
    include HappyMapper
    tag 'apiKey'

    attribute :succeeded, String
    attribute :key, String
  end

  class ResourceTree
    include HappyMapper
    tag 'item'

    attribute :name, String
    attribute :doc_id, String, :tag => 'id'
    attribute :is_folder, Boolean, :tag => 'isFolder'
    has_one :documents, ChiliDoc::DocumentResource, :tag => 'item', :xpath => "item[@id !='' and @isFolder='false']"
  end

  class UrlInfo
    include HappyMapper
    tag 'urlInfo'

    attribute :url, String
  end

  class ResourceHistory
    include HappyMapper
    tag 'item'

    attribute :date, DateTime, :tag => 'dateStamp'
    attribute :description, String
    attribute :user_name, String, :tag => 'userName'
    attribute :detailed, String
  end



  class Task
    include HappyMapper
    tag 'task'

    attribute :task_id, String, :tag => 'id'
    attribute :finished, String
    attribute :started, String
    attribute :succeeded, String
    #has_one :preview, String, :tag=>'result',  :xpath => '//@result//result@URL'
    attribute :result, String
  end




# TODO: this is meant to be an object for Task result
  class PreviewResult
    include HappyMapper
    tag 'result'

    attribute :url, String
  end

end