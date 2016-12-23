require 'digest/md5'
require 'net/http'
require 'uri'

ts = Time.now.to_i.to_s
password = "dood"
token = Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + ts)
params = {"p" => "1.2", "u" => "ruin", "t" => ts, "a" => token, "c" => "test"}

uri = URI('http://localhost:4567/')
uri.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(uri)
puts res.body

sleep 1

session = res.body.split("\n")[1]

uri = URI.parse("http://localhost:4567/submit")
res = Net::HTTP.post_form(uri, {"s" => session, "a[0]" => "The Delgados", "t[0]" => "Mad Drums", "i[0]" => Time.now.to_i})

print res.body
