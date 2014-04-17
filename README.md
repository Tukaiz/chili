chili
=====

This gem uses DocSplit which requires the package PDFTK to be installed.

Has the dependancy for Savon 0.7.8, which works from Rails 2.2 to at least 3.2.8.

If you are using a newer version of Savon, being loaded by your gemfile, then you might need to overload
these two method calls in order for your version of Savon to work properly:

module Chili<br/>
&nbsp;&nbsp;  class ChiliVdp<br/>
<br/>
&nbsp;&nbsp;&nbsp;&nbsp; def initialize(server = "http://chili.my.dev/CHILI/main.asmx?wsdl") <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  # the line below may need to change if your Savon version initializes differently <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  @client = Savon::Client.new(@url=server) <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	self.authenticate <br/>
&nbsp;&nbsp;&nbsp;&nbsp; end <br/>
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;def send_msg(action, hash_obj, return_obj = false) <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  new_hash={};hash_obj.each do |index, obj|;new_hash["wsdl:#{index}"]=obj;end;hash_obj.replace(new_hash) <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  # line below if your Savon version calls to the api differently <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  result = @client.send("#{action}".to_sym) do |soap|; soap.body=hash_obj; end <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  # line below if your Savon result structure has changed <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  xml = result.to_hash["#{action}_response".to_sym]["#{action}_result".to_sym] <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  return_obj ? return_obj.parse(xml) : xml <br/>
&nbsp;&nbsp;&nbsp;&nbsp; end <br/>
<br/>
&nbsp;&nbsp; end <br/>
end<br/>
<br/>
<br/>

