# data structures for content types  
# these can probably be improved
# in particular, 'displayField' could happily sit in 'data'
# if you can make my add_type function work better. 
# You can't select displayField until the fields are created, 
# and my current add_type function adds the fields later
# so it has to select displayField later

require 'contentful/management'
require_relative 'contentful_fields'

# Banner
@banner = {
    data: {
        id: 'banner',
        name: 'Banner',
        description: "An alert you want to display as soon as someone views " \
                    "a piece of advice content. Usually temporary - for example " \
                    "a survey we're currently running"
    },
    fields: [@title_test],
    displayField: 'title',
    appearance: [@title_appearance_invisible]
}
  
# Advice collection - public
@collection_public = {
    data: {
        id: 'adviceCollection',
        name: 'Advice collection - public',
        description: "A self-contained piece of advice that answers " \
                    "a definitive user need from start to end. " \
                    "Appears on the website as a page",
        },
    fields: [
        'title',
        'adviser_title',
        'url_ending',
        'body',
        'meta_description',
        'last_accuracy_review',
        'classification_number',
        'child_content',
        'related_content',
        'banner_field',
        'version_information',
        'start_task_list',
        'chat_category',
        'hide_from_search'
    ],
    displayField: 'title',
    appearance: [
        @title_appearance_visible 
    ]

}