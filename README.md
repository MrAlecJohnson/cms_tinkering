# content_model
Create and edit content models in a reproducible way.

**contentful_api_real** is a framework for whatever creation or change methods I want to run. Specify the changes at the end of this then run it. 

**contentful_functions** is a set of methods for adding, removing and changing types and fields 

**contentful_fields** is a record of all the fields and their associated varieties of interface settings

**contentful_types** records the content types, which fields they include, and which interface settings to apply to each of those fields

The Python file was the version I started with - it's no longer important. You can also ignore contentful_api_test_area and contentful_deliver. These are just for my testing purposes. 

## How Contentful content models fit together
A content model contains a number of content types. 

Each type has some data associated with it - a name, an id and so on. It also has a set of fields. You need to define these fields in advance as field objects. 

Each field object has a set of attributes that define the field. 

In the Contentful web app, each field has an 'appearance' tab that defines how that field works in the web app. This appearance tab is *not* defined in the field object. Instead, each content type has an array called editor_interface that specifies the appearance details to use for each field