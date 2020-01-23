# Functions for manipulating Contentful content model
require 'contentful/management'

def get_type(env, content_type)
    return env.content_types().find(content_type)
end

def add_field(env, content_type)
    t = get_type(env, content_type)
    t.fields.create(:name => 'Test field', :id => 'testField', :type => 'Text')
    t.save()
    interface = t.editor_interface.default
    puts interface
    #interface.controls.each do |control|
    #    if control['fieldId'] == new_field['id']
    #        puts control['settings'] 
    #        break
    #    end
    #end
    #interface.save()
    return 0
end
