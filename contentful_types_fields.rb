# data structures for content types and fields 
# might need to split these into 2 files once I have a few more

require 'contentful/management'

test_appearance = {
    fieldId: 'testField',
    settings: {
        helpText: 'Some words',
        widgetId: 'markdown',
        widgetNamespace: 'builtin'
    }
}

# FIELDS

# Standard title
@title = Contentful::Management::Field.new
@title.id = 'title'
@title.name = 'Title'
@title.type = 'Symbol'
@title.required = true
@title.localized = false
@title.validations = {
    "size": { "min": 5, "max": 100}
}

@title_appearance = {
    fieldId: @title.id,
    settings: {
      helpText: "This title is just for finding the banner in the CMS - " \
                "it doesn't show up when you add the banner to a page"
            },
    widgetId: "singleLine"
}

# TYPES
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
    appearance: [@title_appearance]
}
  
