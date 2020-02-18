require 'contentful'

TOKEN = IO.read("/Users/alec/Python/KEYS/contentful_deliver.txt")

client = Contentful::Client.new(
    space: 'u7djba2yz8zw',
    access_token: TOKEN
)

entry = client.entry('21ZWIJWHShll6ebPBqeVG')

puts entry.sys