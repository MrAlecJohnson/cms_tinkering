# Functions for manipulating Contentful content model
require 'contentful/management'

def content_type(env, type_to_find)
    return env.content_types.find(type_to_find)
end

def field_appearance(content_type, field)
    interface_controls = content_type.editor_interface.default.controls
    return interface_controls.select {|control| control['fieldId'] == field}[0]
end

def add_field(env, existing_type, new_field)
    t = content_type(env, existing_type)
    t.fields.add(new_field)
end

def add_type(env, new_type)
    type_id = new_type[:data][:id]

    created = env.content_types.create(new_type[:data])
    created.publish

    interface = env.editor_interfaces.default(type_id)
    interface.controls = new_type[:appearance]
    interface.save

    #done = content_type(env, type_id)
    #done.save
    puts "Content type #{new_type[:data][:name]} created."

end

