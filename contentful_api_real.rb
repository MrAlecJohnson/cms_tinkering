require 'contentful/management'
require_relative 'contentful_functions'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
client = Contentful::Management::Client.new(KEY)

public_advice = client.spaces.all.items[1].id # This is the public advice space
public_advice_master = client.environments(public_advice).find('master')
public_advice_qa = client.environments(public_advice).find('qa')
public_advice_dev = client.environments(public_advice).find('dev')

# for getting things from the test space
test_area = client.spaces.all.items[0].id # the test area space
test_area_qa = client.environments(test_area).find('qa')
test_area_master = client.environments(test_area).find('master')
test_area_alec = client.environments(test_area).find('alec_test_migration')

# select the env I want for the rest of the script
relevant_env = test_area_master

# content types, categorised - add them here as they're created
pages = []
units = []
dynamic = []
tools = []
metadata = []
everything = [pages, units, dynamic, tools, metadata].flatten.sort

# check for new content types not on these lists
# also check for things on lists that aren't in CMS
current_types = relevant_env.content_types.all.map { |t| t.id }
leftovers = current_types.select do |t|
    !everything.include?(t)
end

legacy = everything.select do |e|
    !current_types.include?(e)
end

continue = true # change back to false when I want to reactivate the type checker
if leftovers.any? or legacy.any? 
    puts 'New types to add to script:', leftovers 
    puts 'Old types still in script:', legacy

else 
    continue = true
end

if continue
    # add stuff you want to do here 
    # use functions from contentful_functions
    puts 'test'
    [public_advice_master, public_advice_qa, public_advice_dev].each do |env|
        add_locale(env, 'English (Scotland)', 'en-SCT')
        add_locale(env, 'English (Wales)', 'en-WLS')
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
end

