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
        fields: [@title]
        },
    appearance: [@title_appearance_invisible]
}
  
