chili
=====

Has the dependancy for Savon 0.7.8, which works from Rails 2.2 to at least 3.2.8.

If you are using a newer version of Savon, being loaded by your gemfile, then you might need to overload
these two method calls in order for your version of Savon to work properly:

1.)

def initialize(server = "http://chili.my.dev/CHILI/main.asmx?wsdl") <br/>
&nbsp;&nbsp;  # the line below may need to change if your Savon version initializes differently <br/>
&nbsp;&nbsp;  @client = Savon::Client.new(@url=server) <br/>
&nbsp;&nbsp;	self.authenticate <br/>
end <br/>

2.)

def send_msg(action, hash_obj, return_obj = false) <br/>
&nbsp;&nbsp;  new_hash={};hash_obj.each do |index, obj|;new_hash["wsdl:#{index}"]=obj;end;hash_obj.replace(new_hash) <br/>
&nbsp;&nbsp;  # line below if your Savon version calls to the api differently <br/>
&nbsp;&nbsp;  result = @client.send("#{action}".to_sym) do |soap|; soap.body=hash_obj; end <br/>
&nbsp;&nbsp;  # line below if your Savon result structure has changed <br/>
&nbsp;&nbsp;  xml = result.to_hash["#{action}_response".to_sym]["#{action}_result".to_sym] <br/>
&nbsp;&nbsp;  return_obj ? return_obj.parse(xml) : xml <br/>
end <br/>


