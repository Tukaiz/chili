require "base64"

module Chili
  class ChiliVdp
    #  hosts file settings for DEV
    # 127.0.0.1 my.dev
    # 206.152.228.225 chili.my.dev

    # ChiliVdp.new.authenticate
    attr_accessor :url, :client, :data, :result, :user, :password, :session_id


    def initialize(server = "http://chili.my.dev/CHILI/main.asmx?wsdl")
      @client = Savon::Client.new(@url=server)
      self.authenticate
    end

    def authenticate(env_name_or_url='training', user_name='api', password='api')
      hash = { 'environmentNameOrURL'=>env_name_or_url, 'userName'=>user_name, 'password'=> password }
      self.session_id = send_msg('generate_api_key', hash, ChiliService::Authentication).key
    end

    def get_resource_tree(resource_name='Documents', parent_folder='', sub_dirs=true, files=true)
      hash = { 'apiKey'=>@session_id, 'resourceName'=>resource_name, 'parentFolder'=>parent_folder, 'includeSubDirectories'=>sub_dirs, 'includeFiles'=>files}
      send_msg('resource_get_tree', hash, ChiliService::ResourceTree)
    end

    def move_document(application, user_id, unique_id, document_id, name)
      copy_or_move_resource('move', 'Documents', document_id, 'orders/#{application}/#{user_id}/#{unique_id}', name, ChiliDoc::DocumentResource)
    end

    def copy_document(application, user_id, unique_id, document_id, document_name)
      copy_or_move_resource('copy', 'Documents', document_id, "tmp/#{application}/#{user_id}/#{unique_id}", "#{document_name}", ChiliDoc::DocumentResource)
    end

    def copy_document_and_return_new_url(application, user_id, unique_id, document_id, document_name, workspace_id=nil, view_prefs=nil, constraints_id=nil)
      new_doc = copy_document(application, user_id, unique_id, document_id, document_name)
      url = get_document_url(new_doc.doc_id, workspace_id, view_prefs, constraints_id)
      { :doc_id=>new_doc.doc_id, :url=>url }
    end

    def get_document_url(document_id, workspace_id=nil, view_prefs=nil, constraints_id=nil)
      hash = { "apiKey"=>@session_id, "itemID"=>document_id }
      hash["workSpaceID"]   = workspace_id   if workspace_id
      hash["viewPrefsID"]   = view_prefs     if view_prefs
      hash["constraintsID"] = constraints_id if constraints_id
      send_msg('document_get_editor_url', hash, ChiliService::UrlInfo).url
    end

    def set_workspace_admin(yes_or_no)
      hash = { "apiKey"=>@session_id, "setWorkspaceAdministration"=>yes_or_no }
      send_msg('set_workspace_administration', hash)
    end

    def get_document_values(document_id)
      hash = { "apiKey"=>@session_id, "itemID"=>document_id }
      send_msg('document_get_variable_values', hash, ChiliDoc::GetDocVals)
    end

    def get_document_definitions(document_id)
      hash = { "apiKey"=>@session_id, "itemID"=>document_id }
      send_msg('document_get_variable_definitions', hash)
    end

    def export_pdf(document_id, xml_settings)
      hash = { "apiKey"=>@session_id, "itemID"=>document_id, "settingsXML"=>xml_settings, "taskPriority"=>1 }
      send_msg('document_create_pdf', hash, ChiliService::Task).task_id
    end

    def task_status(task_id)
      hash = { "apiKey"=>@session_id, "taskID"=>task_id }
      send_msg('task_get_status', hash, ChiliService::Task)
    end

    def get_document_info(document_id)
      hash = { 'apiKey'=>@session_id, 'itemID'=>document_id }
      send_msg('document_get_info', hash, ChiliDoc::DocumentInfo)
    end

    def get_resource_history(resource_name, item_id)
      hash = { 'apiKey'=>@session_id, 'resourceName'=>resource_name, 'itemID'=>item_id }
      send_msg('resource_item_get_history', hash, ChiliService::ResourceHistory)
    end

    def get_document_history(item_id)
      get_resource_history('Documents', item_id)
    end

    def upload_data_file(data_source_id, file_name, raw_data)
      hash = { 'apiKey'=>@session_id, 'dataSourceID'=>data_source_id, 'fileName'=>file_name, 'fileOrData'=>Base64.encode64(raw_data) }
      result_passed?(send_msg('data_source_add_sample_file', hash))
    end

private
    def send_msg(action, hash_obj, return_obj = false)
      new_hash={};hash_obj.each do |index, obj|;new_hash["wsdl:#{index}"]=obj;end;hash_obj.replace(new_hash)
      result = @client.send("#{action}".to_sym) do |soap|; soap.body=hash_obj; end
      xml = result.to_hash["#{action}_response".to_sym]["#{action}_result".to_sym]
      return_obj ? return_obj.parse(xml) : xml
    end

    def copy_or_move_resource(copy_or_move, resource_name, item_id, path, new_name, return_obj = false)
      hash = { "apiKey"=>@session_id, "resourceName"=>resource_name, "itemID"=>item_id, "folderPath"=>path, "newName"=>new_name }
      copy_or_move == 'copy' ? hash["folderPath"] = path : hash["newFolderPath"] = path
      send_msg("resource_item_#{copy_or_move}", hash, return_obj)
    end

    def result_passed?(a)
      a == '<ok/>'
    end

  end
end

