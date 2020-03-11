require 'json'

require_relative 'content_model_methods'

def chat_categories(data)
    # Adds the full set of online chat categories to any
    # content type with an 'Online chat category' field
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

    # hash that will becomethe new json to upload
    new_data = {
            contentTypes: [],
        }

    # The bit below is more or less repeated - would be good to break it into procs or similar
    # It looks through all the content types and finds the ones with an online chat category
    # Then it adds the full list of options to that category and adds that type to new_data
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

    # finds any content type with a meta description and removes its validations
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
    # list of types to change: only types with a rich text field with embeddings and style options
    types = [
        'adviceCollection',
        'callout',
        'calloutAdviser',
        'contentPattern',
        'locationSpecificContent',
        'targetedContent',
        'targetedContentAdviser'
    ]
    
    # 2 hashes of things you can add to rich text - Contentful splits them into 'nodes' and 'marks'
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

    # hash that will become the import json
    new_data = {
            contentTypes: [],
        }

    # runs on each of the previously specified content types
    # deletes current node and mark validations for rich text fields and adds the new ones
    # this should have the helpful side effect of removing any current inconsistencies
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

def add_adviser_warning_field(data)
    # creates a new field in the specified list of types
    # the new field is a single-entry reference called 'adviser warning'
    types = [
        'adviceCollection',
        'adviceCollectionAdviser',
        'adviceList'
    ]

    new_field = {
        "id": "adviserWarning",
        "name": "Adviser warning",
        "type": "Link",
        "localized": false,
        "required": false,
        "validations": [
          {
            "linkContentType": [
              "adviserWarning"
            ]
          }
        ],
        "disabled": false,
        "omitted": false,
        "linkType": "Entry"
      }

    # contentful stores help text in the 'editor interfaces' section, not the content type
    help_text = {
        "fieldId": "adviserWarning",
        "settings": {
          "helpText": "Adds an adviser-only sticky box to the top of the page, like on the immigration public pages"
        },
        "widgetId": "entryLinkEditor",
        "widgetNamespace": "builtin"
    }

    new_data = {
        contentTypes: [],
        editorInterfaces: []
    }

    to_change = data['contentTypes'].select{|t| types.include? t['sys']['id']}
    to_change.each do |t|
        fields = t['fields']
        # delete the field if it already exists 
        fields.delete_if do |field|
            field['id'] == "adviserWarning"
        end
        # then add the new field and add the edited type to the import data hash
        fields << new_field
        new_data[:contentTypes] << t
    end

    # get the editor interfaces for the relevant content types - these cover appearance
    appearance = data['editorInterfaces'].select do |t| 
        types.include? t['sys']['contentType']['sys']['id']
    end

    # as with the fields, delete the entry if it already exists, then add the new help text
    appearance.each do |t|
        t['controls'].delete_if do |control|
            control['fieldId'] == "adviserWarning"
        end
        t['controls'] << help_text
        new_data[:editorInterfaces] << t
    end

    return new_data

end


def add_3rd_list_style(data)
    # removes the 'list style' boolean on index pages
    # changes it to a 3-option choice of styles 
    # CURRENTLY INCOMPLETE
    types = [
        'adviceList'
    ]

    new_field = {
        "id": "listStyle",
        "name": "List style",
        "type": "Array",
        "localized": false,
        "required": true,
        "validations": [
        ],
        "disabled": false,
        "omitted": false,
        "items": {
          "type": "Symbol",
          "validations": [
            {
              "in": [
                "Text list",
                "Box list",
                "List subheading"
              ]
            }
          ]
        }
      }
end
