chili
=====

Has the dependancy for Savon 0.7.8, which works from Rails 2.2 to at least 3.2.8.

If you are using a newer version of Savon, being loaded by your gemfile, then you might need to overload
these two method calls in order for your version of Savon to work properly:

1.)

def initialize(server = "http://chili.my.dev/CHILI/main.asmx?wsdl")
  # the line below may need to change if your Savon version initializes differently
  @client = Savon::Client.new(@url=server)
	self.authenticate
end

2.)

def send_msg(action, hash_obj, return_obj = false)
  new_hash={};hash_obj.each do |index, obj|;new_hash["wsdl:#{index}"]=obj;end;hash_obj.replace(new_hash)
  # line below if your Savon version calls to the api differently
  result = @client.send("#{action}".to_sym) do |soap|; soap.body=hash_obj; end
  # line below if your Savon result structure has changed
  xml = result.to_hash["#{action}_response".to_sym]["#{action}_result".to_sym]
  return_obj ? return_obj.parse(xml) : xml
end


