# Functions for manipulating Contentful content model
require 'contentful/management'
require 'json'


# Methods for getting information from Contentful

def content_type(env, content_type_id)
    return env.content_types.find(content_type_id)
end

def content_type_appearance(content_type)
    return content_type.editor_interface.default.controls
end

def field_data(env, content_type_id, field_id)
    parent_type = content_type(env, content_type_id).fields
    current_field = parent_type.select {|field| field.id == field_id}[0]
end

def field_appearance(content_type, field_id)
    # work out if it would be better to use content_type_id here instead
    # currently you have to pass it the actual content type object
    type_appearance = content_type_appearance(content_type)
    return type_appearance.select {|control| control['fieldId'] == field_id}[0]
end

def all_data_for_type(env, content_type_id)
    original = content_type(env, content_type_id)
    appearance = content_type_appearance(original)
    type_info = {
        data: {
            id: original.id,
            name: original.name,
            description: original.description,
            displayField: original.display_field,
            fields: original.fields
        },
        appearance: appearance
    }
    return type_info
end

# Methods for creating new fields and types

def new_field(id, attribute_hash)
    #field = Contentful::Management::Field.new
    #field.id = id
    #attribute_hash.each do |k, v|
    #    field.k = v
    #end
    #return field
end

def add_field_to_type(env, existing_type, new_field_data, new_field_appearance = nil)
    t = content_type(env, existing_type)
    t.fields.add(new_field_data)
    t.publish()

    if new_field_appearance
        interface = t.editor_interface.default
        num = interface.controls.find_index { |i| i['fieldId'] == new_field_data.id }
        interface.controls[num] = new_field_appearance
        interface.save
    end
end

def add_type(env, new_type)
    type_id = new_type[:data][:id]

    created = env.content_types.create(new_type[:data])
    created.publish

    interface = env.editor_interfaces.default(type_id)
    interface.controls = new_type[:appearance]
    interface.save

    puts "Content type '#{new_type[:data][:name]}' created."

end


# Methods for moving content types around

def export_type_data(env, content_type_id)
    details = content_type(env, content_type_id)
    appearance = content_type_appearance(details)
    File.open(content_type_id.to_s + '.json', "w") do |f|
        f.write(details.properties)
    end
    File.open(content_type_id.to_s + '_appearance.json', "w") do |f|
        f.write(appearance)
    end    
end

def copy_type_to_env(old_env, new_env, content_type_id)
    # If this throws errors, it's probably because the original type in 
    # the old environment has validations or references that involve 
    # content types that don't yet exist in the environment you're copying to
    add_type(new_env, all_data_for_type(old_env, content_type_id))
end

def copy_field_to_type(env, field_id, original_type, new_type)
    original_field = field_data(env, original_type, field_id)
    original_field_appearance = field_appearance(content_type(env, original_type), field_id)

    add_field_to_type(env, new_type, original_field, original_field_appearance)
end