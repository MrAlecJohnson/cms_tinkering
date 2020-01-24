require 'contentful/management'
require_relative 'contentful_functions'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip()
client = Contentful::Management::Client.new(KEY)

space = client.spaces.all.items[2].id
env = client.environments(space).find('master')
types = env.content_types.all.map { |t| t.id }

# content types, categorised
pages = ['adviceCollection', 
    'adviceCollectionAdviser', 
    'adviceList']

units = ['adviceUnit', 
    'adviceUnitAdviser',
    'callout',
    'calloutAdviser', 
    'circumstantialUnit',
    'circumstantialUnitAdviser']

dynamic = ['banner', 
      'table',
      'adviserWarning',
      'amount',
      'backgroundText',
      'callCosts',
      'contactDetails',
      'contentPattern',
      'legislationLink']

tools = ['tool', 
    'resultPage',
    'question',
    'answer']

metadata = ['topic', 'testType']

sublists = [pages, units, dynamic, tools, metadata]
everything = sublists.flatten.sort

# check for new content types not on these lists
# also check for things on lists that aren't in CMS
leftovers = types.select do |t|
    !everything.include?(t)
end

legacy = everything.select do |e|
    !types.include?(e)
end

# Collection of types and fields to use
test_field = Contentful::Management::Field.new
test_field.id = 'testField'
test_field.name = 'Test field'
test_field.type = 'Text'

test_appearance = {
    fieldId: 'testField',
    settings: {
        helpText: 'Some words',
        widgetId: 'markdown',
        widgetNamespace: 'builtin'
    }
}

continue = false
if leftovers.any? or legacy.any? 
    puts 'New types to add to script:', leftovers 
    puts 'Old types still in script:', legacy

else 
    continue = true
end

if continue
    #type = get_type(env, 'testType')
    #type.fields.create(id: 'newField', name: 'New field', type: 'Text')
    #type.fields.add(test_field)
    add_field(env, 'testType', test_field)
    puts 'Done'
end