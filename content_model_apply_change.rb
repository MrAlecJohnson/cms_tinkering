require 'date'
require 'json'

require_relative 'content_model_changes'
require_relative 'content_model_methods'

# KEYS AND CONSTANTS
KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key
PUBLIC_ADVICE = IO.read("/Users/alec/Python/KEYS/contentful_pa.txt").strip()
NOW = DateTime.now.strftime("%Y_%m_%d")

# CONFIG VARIABLES
export_only = false # sometimes I just want to look at the export json
environment = 'content_playground' # content_playground, dev, qa, master
to_run = 'add_adviser_warning_field' # the name of the change method to run, as a string

export_file = "changes/#{to_run}_#{environment}_export_#{NOW}.json" 
import_file = "changes/#{to_run}_#{environment}_import_#{NOW}.json"

# RUNNABLE SHELL COMMANDS
# shell command to export content
export = "contentful space export " +
    "--space-id #{PUBLIC_ADVICE} " +
    "--environment-id #{environment} " + 
    "--skip-content --skip-roles --skip-webhooks " + 
    "--content-file #{export_file}"

# shell command to import content 
import = "contentful space import " +
    "--content-file #{import_file} " +
    "--space-id #{PUBLIC_ADVICE} " +
    "--environment-id #{environment} " + 
    "--content-model-only --skip-locales"

# THE ACTUAL SCRIPT
# run the export command
`#{export}`
puts "exported from #{environment} to #{export_file}"

unless export_only
    # Pass exported data to the specified change method, then save as new file
    file = File.read(export_file)
    data = JSON.parse(file)

    new_data = send(to_run, data)

    File.open(import_file, "w") do |f|
        f.write(JSON.pretty_generate(new_data))
    end

    # import the new file into the target environment
    `#{import}`
    puts "imported from #{import_file} to #{environment}"
end