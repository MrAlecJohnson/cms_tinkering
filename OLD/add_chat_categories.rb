require 'json'

file = File.read('types/export.json')
data = JSON.parse(file)

chat_options = [
    "Standard chat", 
    "No chat", 
    "Universal Credit", 
    "Help to Claim contact page", 
    "Debt", 
    "Debt - Northern Ireland", 
    "Scams", 
    "Scams landing page", 
    "Consumer", 
    "Consumer - contact us", 
    "Contact us page", 
    "Chat training"
]

new_data = {
        contentTypes: [],
    }

data['contentTypes'].each do |t|
    type_id = t['sys']['id']
    fields = t['fields']
    fields.each do |f| 
        if f['id'] == 'onlineChatCategory'
            f['validations'][0]['in'] = chat_options
            new_data[:contentTypes] << t
        end
    end
end

File.open('types/chat_categories.json', "w") do |f|
    f.write(JSON.pretty_generate(new_data))
end