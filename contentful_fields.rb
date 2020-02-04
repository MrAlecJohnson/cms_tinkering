# data structures for fields  
# could probably make a nice class/function approach to doing this
# but keeping it versatile and long-winded for now

require 'contentful/management'

# TITLES
# Standard title
# test function version

@title_test = new_field('title', {
    name: 'Title',
    type: 'Symbol',
    required: true,
    validations: {
        "size": { "min": 5, "max": 200}
    }
})

@title = Contentful::Management::Field.new
@title.id = 'title'
@title.name = 'Title'
@title.type = 'Symbol'
@title.required = true
@title.localized = false
@title.validations = {
    "size": { "min": 5, "max": 200}
}

@title_appearance_visible = {
    fieldId: @title.id,
    settings: {
      helpText: "The title of this piece of content." \
                "Visible when you publish to a website."
            },
    widgetId: "singleLine"
}

@title_appearance_invisible = {
    fieldId: @title.id,
    settings: {
        helpText: "This title is just for finding content in the CMS - " \
                "it doesn't show up when you publish this content on a website."
            },
    widgetId: "singleLine"    
}

# Adviser title
@adviser_title = Contentful::Management::Field.new
@adviser_title.id = 'adviserTitle'
@adviser_title.name = 'Adviser title'
@adviser_title.type = 'Symbol'
@adviser_title.required = false
@adviser_title.localized = false
@adviser_title.validations = {
    "size": { "min": 5, "max": 200}
}

@adviser_title_appearance = {
    fieldId: @adviser_title.id,
    settings: {
      helpText: "An alternative title advisers will see."
            },
    widgetId: "singleLine"
}

# Url ending (aka slug)
@url_ending = Contentful::Management::Field.new
@url_ending.id = 'urlEnding'
@url_ending.name = 'Url ending'
@url_ending.type = 'Symbol'
@url_ending.required = true
@url_ending.localized = false
@url_ending.validations = {
    "size": { "min": 5, "max": 200},
    "unique": true
}

# Short url

# RICH TEXT
# Simple text - just text and links - eg banner body field
@body_simple = Contentful::Management::Field.new
@body_simple.id = 'body_limited'
@body_simple.name = 'Body'
@body_simple.type = 'RichText'
@body_simple.required = false
@body_simple.localized = false
@body_simple.validations = {
    "size": { "max": 255},
    "enabledMarks": ["bold"],
    "enabledNodeTypes": [
      "hyperlink",
      "entry-hyperlink"]
}

@body_limited_appearance = {
    fieldId: @body_simple.id,
    settings: {
      helpText: "This text  " \
                "it doesn't show up when you add the banner to a page"
            }
}
