require 'contentful/management'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
client = Contentful::Management::Client.new(KEY)

# for getting things from the test space
space = client.spaces.all.items[0].id # the test area space
qa = client.environments(space).find('qa')

test_type = qa.content_types.find('test')

#test_type.fields.each do |field| 
#    if field.type == 'RichText'
#        field.validations.pop()
#    end
#end

test_type.fields.create(id: 'title_field_id', name: 'Post Title', type: 'Text')

test_type.save
