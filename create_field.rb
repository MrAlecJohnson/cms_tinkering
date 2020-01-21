require 'faraday'
require 'contentful/management'

auth = IO.read("/Users/alec/Python/KEYS/contentful.txt").split(/\n/)
KEY = auth[0]
ID = auth[1]

client = Contentful::Management::Client.new(KEY)

env = client.environments(ID).find('master')
space = client.spaces.find(ID)
types = env.content_types.all