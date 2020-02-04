# Functions for manipulating Contentful content model
require 'contentful/management'
require 'json'

def export_type(env, content_type_id)
    details = content_type(env, content_type_id)
    appearance = content_type_appearance(details)
    File.open(content_type_id.to_s + '.json', "w") do |f|
        f.write(details.properties)
    end
    File.open(content_type_id.to_s + '_appearance.json', "w") do |f|
        f.write(appearance)
    end    
end

def content_type(env, type_to_find)
    return env.content_types.find(type_to_find)
end

def content_type_appearance(content_type)
    return content_type.editor_interface.default.controls
end

def field_appearance(content_type, field)
    type_appearance = content_type_appearance(env, content_type)
    return type_appearance.select {|control| control['fieldId'] == field}[0]
end

def new_field(id, attribute_hash)
    field = Contentful::Management::Field.new
    field.id = id
    attribute_hash.each do |k, v|
        field.k = v
    end
    return field
end

def add_field_to_type(env, existing_type, new_field)
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
    puts "Content type '#{new_type[:data][:name]}' created."

end

