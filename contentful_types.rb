# data structures for content types  

require 'contentful/management'
require_relative 'contentful_fields'

# Banner
@banner = {
    data: {
        id: 'banner',
        name: 'Banner',
        description: "An alert you want to display as soon as someone views " \
                    "a piece of advice content. Usually temporary - for example " \
                    "a survey we're currently running",
        displayField: 'title',
        fields: [@title_test]
        },
    appearance: [@title_appearance_invisible]
}
  
# Advice collection - public
@collection_public = {
    data: {
        id: 'adviceCollection',
        name: 'Advice collection - public',
        description: "A self-contained piece of advice that answers" \
                    "a definitive user need from start to end." \
                    "Appears on the website as a page",
        displayField: 'title',
        fields: [@title]
        },
    appearance: [
        @title_appearance_visible, 
    ]

}