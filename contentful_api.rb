require 'faraday'
require 'contentful/management'

auth = IO.read("/Users/alec/Python/KEYS/contentful.txt").split(/\n/)
KEY = auth[0]
ID = auth[1]

client = Contentful::Management::Client.new(KEY)

#spaces = client.spaces.all
#spaces.each do |space|
#    puts space.name
#    puts space.id
#end
#envs = client.environments(ID).all

env = client.environments(ID).find('master')
space = client.spaces.find(ID)
types = env.content_types.all

types.each do |t|
    if t.name == 'List'
        puts t.id
        parts = t.fields
        parts.each do |f|
            puts f.name
            puts f.id
        end
    end

end