# move content types from one space and environment to another 
# you need to be logged in to the contentful CLI first
# I wonder if I could do that here too? 
# should probably change config variables to argv

require 'json'
require 'contentful/management'

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
PUBLIC_ADVICE = IO.read("/Users/alec/Python/KEYS/contentful_pa.txt").strip()
TEST_AREA = IO.read("/Users/alec/Python/KEYS/contentful_ta.txt").strip()

#CONFIG VARIABLES
export_only = false
import_content = true # to copy published content entries as well as types
import_locales = false # not yet implemented 
empty_space_first = true # beware - deletes all content and types from import env!

export_space = PUBLIC_ADVICE # public space
export_env = 'dev'
import_space = TEST_AREA # test area
import_env = 'qa'
export_file = 'types/export.json'
import_file = 'types/import.json'
# imports all types if types_to_keep is empty
types_to_keep = [] 

# RUNNABLE SHELL COMMANDS
if import_content
    entries = ''
    # --query-entries 'content_type=adviceCollection' THIS WORKS
    # --query-entries 'content_type[in]=adviceCollection,adviceList' THIS DOESN'T
    model = ''
else
    entries = '--skip-content '
    model = '--content-model-only --skip-locales'
end

export = "contentful space export " +
    "--space-id #{export_space} " +
    "--environment-id #{export_env} " + 
    "#{entries + ' ' or ''}--skip-roles --skip-webhooks " + 
    "--content-file #{export_file}"

import = "contentful space import " +
    "--content-file #{import_file} " +
    "--space-id #{import_space} " +
    "--environment-id #{import_env} " + 
    "#{model + ' ' or ''}"

# METHODS FOR IMPORT AND EXPORT
def import_some_types(data, types_to_copy, import_content = false)
    new_data = {
        contentTypes: [],
        editorInterfaces: []
    }
        
    data['contentTypes'].each do |t|
        type_id = t['sys']['id']
        if types_to_copy.include?(type_id)
            new_data[:contentTypes] << t
        end
    end
    
    data['editorInterfaces'].each do |e|
        type_id = e['sys']['contentType']['sys']['id']
        if types_to_copy.include?(type_id)
            new_data[:editorInterfaces] << e
        end
    end

    if import_content
        new_data[:entries] = []
        data['entries'].each do |e|
            type_id = e['sys']['contentType']['sys']['id']
            if types_to_copy.include?(type_id)
                new_data[:entries] << e
            end
        end
    end

    return new_data
end

def import_all_types(data, import_content = false)
    new_data = {
        contentTypes: data['contentTypes'],
        editorInterfaces: data['editorInterfaces']
    }

    if import_content
        new_data[:entries] = data['entries']
    end

    return new_data
end

def empty_env(target_space, target_env)
    client = Contentful::Management::Client.new(KEY)
    env = client.environments(target_space).find(target_env)
    existing = env.entries.all
    existing.each do |entry|
        entry.unpublish
        entry.destroy
    end

    current_types = env.content_types.all.map { |t| t.id }
    current_types.each do |t|  
        target = env.content_types.find(t)
        target.deactivate
        target.destroy
    end
end

# THE ACTUAL SCRIPT
# run the export command
`#{export}`

file = File.read(export_file)
data = JSON.parse(file)

# read the exported data and write the relevant bits to new file
if types_to_keep.empty?
    new_data = import_all_types(data, import_content) 
else
    new_data = import_some_types(data, types_to_keep, import_content)
end

File.open(import_file, "w") do |f|
    f.write(JSON.pretty_generate(new_data))
end

# delete the existing types and content if desired
if empty_space_first
    empty_env(import_space, import_env)
end

# import the new file into the target environment
unless export_only
    `#{import}`
end
