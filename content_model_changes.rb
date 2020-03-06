require 'json'

require_relative 'content_model_methods'

def chat_categories(data)
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

    return new_data

end

def remove_meta_description_validation(data)
    new_data = {
            contentTypes: [],
        }

    data['contentTypes'].each do |t|
        type_id = t['sys']['id']
        fields = t['fields']
        fields.each do |f| 
            if f['id'] == 'metaDescription'
                f['required'] = false
                f['validations'] = []
                new_data[:contentTypes] << t
            end
        end
    end

    return new_data
end

def rich_text_styling(data)
    types = [
        'adviceCollection',
        'callout',
        'calloutAdviser',
        'contentPattern',
        'locationSpecificContent',
        'targetedContent',
        'targetedContentAdviser'
    ]
    
    permitted_nodes = {
        "enabledNodeTypes": [
          "heading-2",
          "heading-3",
          "heading-4",
          "ordered-list",
          "unordered-list",
          "embedded-entry-block",
          "embedded-asset-block",
          "hyperlink",
          "entry-hyperlink",
          "asset-hyperlink",
          "embedded-entry-inline"
        ],
        "message": "Only headings 2 to 4, ordered lists, unordered lists, assets, links and embedded entries are allowed"
      }

    permitted_marks = {
        "enabledMarks": [
          "bold"
        ],
        "message": "Only bold marks are allowed"
      }

    new_data = {
            contentTypes: [],
        }

    to_change = data['contentTypes'].select{|t| types.include? t['sys']['id']}
    to_change.each do |t|
        fields = t['fields']
        fields.each do |f| 
            if f['id'] == 'body'
                f['validations'].delete_if do |v|
                    v.key?("enabledNodeTypes") or v.key?("enabledMarks")
                end
                    f['validations'] << permitted_marks
                    f['validations'] << permitted_nodes
                
            end           
        end
        new_data[:contentTypes] << t
    end
    return new_data
end