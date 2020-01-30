require 'contentful/management'
require_relative 'contentful_functions'
require_relative 'contentful_types_fields'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
client = Contentful::Management::Client.new(KEY)

space = client.spaces.all.items[3].id # This is the public advice space
env = client.environments(space).find('master') # we dont' currently have any other envs
types = env.content_types.all.map { |t| t.id }

# for getting things from the test space
old_space = client.spaces.all.items[2].id
old_env = client.environments(old_space).find('master')
old_types = old_env.content_types.all.map { |t| t.id }

# content types, categorised - add them here as they're created
pages = []
units = []
dynamic = []
tools = []
metadata = []
everything = [pages, units, dynamic, tools, metadata].flatten.sort

# check for new content types not on these lists
# also check for things on lists that aren't in CMS
leftovers = types.select do |t|
    !everything.include?(t)
end

legacy = everything.select do |e|
    !types.include?(e)
end

continue = false
if leftovers.any? or legacy.any? 
    puts 'New types to add to script:', leftovers 
    puts 'Old types still in script:', legacy

else 
    continue = true
end

if continue
    # add stuff you want to do here 
    # use functions from contentful_functions
    # keep the objects themselves in contentful_types_fields
    # I should really set up classes for these but my Ruby is blah
    add_type(env, @banner)
    #puts content_type(env, 'banner')
end