# transforms the exported types into the ones I want
# make this into a set of functions so I can call it without repetition
require 'json'

file = File.read('types/exported_types.json')
data_hash = JSON.parse(file)

types_to_keep = [
    'adviceCollection', 
    'adviceList',
    'adviserWarning',
    'backgroundText',
    'banner',
    'calloutAdviser',
    'callout',
    'contactDetails',
    'contentPattern',
    'locationSpecificContent',
    'amount',
    'table',
    'targetedContentPublic',
    'targetedContentAdviser'
]

types_to_update = [
    'testType'
]

def some_types(data, type_array)
    new_data = {
        contentTypes: Array.new,
        editorInterfaces: Array.new
    }
        
    data['contentTypes'].each do |t|
        type_id = t['sys']['id']
        if type_array.include?(type_id)
            new_data[:contentTypes].push(t)
        end
    end
    
    data['editorInterfaces'].each do |e|
        type_id = e['sys']['contentType']['sys']['id']
        if type_array.include?(type_id)
            new_data[:editorInterfaces].push(e)
        end
    end
    return new_data
end

def all_types(data)
    new_data = {
        contentTypes: data['contentTypes'],
        editorInterfaces: data['editorInterfaces']
    }
    return new_data
end

new_data = all_types(data_hash) 

File.open('types/for_import.json', "w") do |f|
  f.write(new_data.to_json)
end
