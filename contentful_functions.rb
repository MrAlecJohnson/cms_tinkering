# Functions for manipulating Contentful content model
require 'contentful/management'

def content_type(env, type_to_find)
    return env.content_types.find(type_to_find)
end

def add_field(env, existing_type, new_field)
    t = content_type(env, existing_type)
    t.fields.add(new_field)
    #interface = t.editor_interface.default
    #puts interface
    #interface.controls.each do |control|
    #    if control['fieldId'] == new_field['id']
    #        puts control['settings'] 
    #        break
    #    end
    #end
    #interface.save()
    return 0
end
