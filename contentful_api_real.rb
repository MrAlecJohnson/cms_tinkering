require 'contentful/management'
require_relative 'contentful_functions'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
client = Contentful::Management::Client.new(KEY)

public_advice = client.spaces.all.items[1].id # This is the public advice space
public_advice_master = client.environments(public_advice).find('master')
public_advice_qa = client.environments(public_advice).find('qa')
public_advice_dev = client.environments(public_advice).find('dev')
public_advice_playground = client.environments(public_advice).find('content_playground')

# select the env I want for the rest of the script
relevant_env = public_advice_playground
current_types = relevant_env.content_types.all.map { |t| t.id }

# add stuff you want to do here 
# use functions from contentful_functions
puts 'test'
current_types[0..1].each do |content|
    fields = content_type(relevant_env, content).fields
    if fields 
end

# DO FOR AN ARRAY
#types_to_copy.each do |t|
#    copy_field_to_type(old_env, t, 'adviceCollection', 'adviceList')
#end

#DELETE ALL CONTENT - DON'T DO THIS UNLESS YOU REALLY WANT TO!
#existing = relevant_env.entries.all
#existing.each do |entry|
#    entry.unpublish
#    entry.destroy
#end

# DO FOR ALL CONTENT TYPES
#current_types.each do |t|  
#    delete_type(relevant_env, t)  
#end
