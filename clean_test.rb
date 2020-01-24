require 'contentful/management'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip()
client = Contentful::Management::Client.new(KEY)

space = client.spaces.all.items[1].id
env = client.environments(space).find('master')

new_type_title = Contentful::Management::Field.new
new_type_title.id = 'title'
new_type_title.name = 'Title'
new_type_title.type = 'Text'

new_field = Contentful::Management::Field.new
new_field.id = 'test'
new_field.name = 'Test'
new_field.type = 'Text'

#env.content_types.create(name: 'Experiment', id: 'experiment', fields: [new_type_title])

type = env.content_types.find('experiment')
type.fields.create(id: 'second', name: 'Second test', type: 'Text')
#type.fields.add(new_field)
#type.save()