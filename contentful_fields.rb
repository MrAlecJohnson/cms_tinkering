# data structures for fields  

require 'contentful/management'

# TITLES
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

@title_appearance_banner = {
    fieldId: @title.id,
    settings: {
      helpText: "This title is just for finding the banner in the CMS - " \
                "it doesn't show up when you add the banner to a page"
            },
    widgetId: "singleLine"
}

# RICH TEXT
# Just text and links - eg banner body field
@body_limited = Contentful::Management::Field.new
@body_limited.id = 'body_limited'
@body_limited.name = 'Body'
@body_limited.type = 'RichText'
@body_limited.required = false
@body_limited.localized = false
@body_limited.validations = {
    "size": { "max": 255},
    "enabledMarks": ["bold"],
    

    #<Contentful: : Management: : Validation: @properties={
        : in=>nil,
        : size=>{
          "max"=>255
        },
        : range=>nil,
        : regexp=>nil,
        : unique=>false,
        : present=>false,
        : linkField=>false,
        : assetFileSize=>nil,
        : linkContentType=>nil,
        : linkMimetypeGroup=>nil,
        : assetImageDimensions=>nil,
        : enabledNodeTypes=>nil,
        : enabledMarks=>nil
      }>,
      #<Contentful: : Management: : Validation: @properties={
        : in=>nil,
        : size=>nil,
        : range=>nil,
        : regexp=>nil,
        : unique=>false,
        : present=>false,
        : linkField=>false,
        : assetFileSize=>nil,
        : linkContentType=>nil,
        : linkMimetypeGroup=>nil,
        : assetImageDimensions=>nil,
        : enabledNodeTypes=>nil,
        : enabledMarks=>nil
      }>,
      #<Contentful: : Management: : Validation: @properties={
        : in=>nil,
        : size=>nil,
        : range=>nil,
        : regexp=>nil,
        : unique=>false,
        : present=>false,
        : linkField=>false,
        : assetFileSize=>nil,
        : linkContentType=>nil,
        : linkMimetypeGroup=>nil,
        : assetImageDimensions=>nil,
        : enabledNodeTypes=>nil,
        : enabledMarks=>[
          "bold"
        ]
      }>,
      #<Contentful: : Management: : Validation: @properties={
        : in=>nil,
        : size=>nil,
        : range=>nil,
        : regexp=>nil,
        : unique=>false,
        : present=>false,
        : linkField=>false,
        : assetFileSize=>nil,
        : linkContentType=>nil,
        : linkMimetypeGroup=>nil,
        : assetImageDimensions=>nil,
        : enabledNodeTypes=>[
          "hyperlink",
          "entry-hyperlink"
        ],
        : enabledMarks=>nil
      }>
  

}

@body_limited_appearance = {
    fieldId: @body_limited.id,
    settings: {
      helpText: "This text  " \
                "it doesn't show up when you add the banner to a page"
            }
}
