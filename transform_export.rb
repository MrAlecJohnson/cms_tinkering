# transforms the exported types into the ones I want
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

new_data = {
    "contentTypes": Array.new,
    "editorInterfaces": Array.new
}

data_hash['contentTypes'].each do |t|
    type_id = t['sys']['id']
    if types_to_keep.include?(type_id)
        new_data[:contentTypes].push(t)
    end
end

data_hash['editorInterfaces'].each do |e|
    type_id = e['sys']['contentType']['sys']['id']
    if types_to_keep.include?(type_id)
        new_data[:editorInterfaces].push(e)
    end
end

File.open('types/for_import.json', "w") do |f|
  f.write(new_data.to_json)
end
