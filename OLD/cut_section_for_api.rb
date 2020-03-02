# cut bit for checking content type presence


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