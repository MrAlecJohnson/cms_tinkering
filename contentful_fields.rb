# data structures for fields  
# could probably make a nice class/function approach to doing this
# but keeping it versatile and long-winded for now

require 'contentful/management'

# TITLES
# Standard title
@title = {
    id: 'title',
    name: 'Title',
    type: 'Symbol',
    required: true,
    validations: {
        "size": { "min": 5, "max": 200},
        "unique": true
    }
}

@title_appearance_visible = {
    fieldId: @title['id'],
    settings: {
      helpText: "The title of this piece of content." \
                "Visible when you publish to a website."
            },
    widgetId: "singleLine"
}

@title_appearance_invisible = {
    fieldId: @title['id'],
    settings: {
        helpText: "This title is just for finding content in the CMS - " \
                "it doesn't show up when you publish this content on a website."
            },
    widgetId: "singleLine"    
}

# Adviser title
@adviser_title = {
    id: 'adviserTitle',
    name: 'Adviser title',
    type: 'Symbol',
    required: false,
    validations: {
        "size": { "min": 5, "max": 200},
        "unique": true

    }
}

@adviser_title_appearance = {
    fieldId: @adviser_title['id'],
    settings: {
      helpText: "An alternative title advisers will see."
            },
    widgetId: "singleLine"
}

# Url ending (aka slug)
@url_ending = {
    id: 'urlEnding',
    name: 'Url ending',
    type: 'Symbol',
    required: true,
    validations: {
        "size": { "min": 5, "max": 200},
        "unique": true
    }
}


# RICH TEXT
# Standard body content - eg in a collection
# much embedding is permitted
@body = {
    id: 'body',
    name: 'Body',
    type: 'RichText',
    required: false,
    validations: {
        "enabledMarks": [
            "bold",
            "italic"
        ],
        "enabledNodeTypes": [
            "heading-2",
            "heading-3",
            "heading-4",
            "ordered-list",
            "unordered-list",
            "hr",
            "blockquote",
            "embedded-entry-block",
            "embedded-asset-block",
            "hyperlink",
            "entry-hyperlink",
            "asset-hyperlink",
            "embedded-entry-inline"
          ]
        }
}

# Simple text - just text and links - eg banner body field
# still called 'body' in interface as users don't care it's simplified
@body_simple = {
    id: 'bodySimple',
    name: 'Body',
    type: 'RichText',
    required: false,
    validations: {
        "size": {"max": 255},
        "enabledMarks": ["bold"],
        "enabledNodeTypes": [
          "hyperlink",
          "entry-hyperlink"]
        }
}

@body_simple_appearance = {
    fieldId: @body_simple['id'],
    settings: {
      helpText: "This text  " \
                "it doesn't show up when you add the banner to a page"
            }
}

# REFERENCE FIELDS
# child content - for page-level types like collections and lists
@child_content = {
    id: 'childContent',
    name: 'Child content',
    type: "Array",
    items: {
        type: 'Link',
        linkType: "Entry",
        required: false,
        validations: {
            "linkContentType": [
                "adviceCollectionAdviser",
                "adviceCollection",
                "adviceList"
            ]  
        }
    }
}

# related content, for those side navigation menus on old pages
@related_content = {
    id: 'relatedContent',
    name: 'Related content',
    type: "Array",
    items: {
        type: 'Link',
        linkType: "Entry",
        required: false,
        validations: {
            "linkContentType": [
                "adviceCollectionAdviser",
                "adviceCollection"
            ]  
        }
    }
}

# field for referencing a banner content type
# applies to page-level content types - appears as a stripe across the top of the page
@banner_field = {
    id: 'banner',
    name: 'Banner',
    type: "Link",
    linkType: "Entry",
    required: false,
    validations: {
        "linkContentType": [
            "banner"
        ]  
    }
}


# METADATA
# Meta description
@meta_description = {
    id: 'metaDescription',
    name: 'Meta description',
    type: 'Text',
    required: false,
    validations: {
        "size": {"min": 70, "max": 255},  
    }
}

# Last accuracy review date - manually entered after full legal checks
@last_accuracy_review = {
    id: 'lastAccuracyReview',
    name: 'Last accuracy review',
    type: 'Date',
    required: false
}

# Classification number is a code advisers use to reference documents
# It also lets advisers skip directly to that document using search
@classification_number = {
    id: 'classificationNumber',
    name: 'Classification number',
    type: 'Symbol',
    required: false,
    validations: {
        "unique": true,
        "regexp": {
            "pattern": "^(?:\\d{1,3}\\.){4}$"
        }
    }
}

# Version information 
@version_info = {
    id: 'versionInformation',
    name: 'Version information',
    type: 'Text',
    required: true
}

# the webchat options are TBC with help from ops team
# the current ones seem overcomplicated
@chat_category = {
    id: 'chatCategory',
    name: 'Online chat category',
    type: "Symbol",
    linkType: "Entry",
    required: true,
    validations: {
        "in": [
            "Normal chat",
            "No chat",
            "Debt",
            "Universal Credit",
            "Help to Claim contact page",
            "Scams",
            "Consumer - contact us",
            "Debt - Northern Ireland"
        ]  
    }
}



# FLAGS
# Switch on task lists 
@start_task_list = {
    id: 'startTaskList',
    name: 'Start of task list?',
    type: 'Boolean',
    required: true
}

# Hide from search engines (internal and external) and navigation 
@hide_from_search = {
    id: 'hideFromSearch',
    name: 'Hide from search engines?',
    type: 'Boolean',
    required: true
}