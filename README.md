# content_model
This is a reusable way to export a content model from an environment, transform that model (or just select the relevant types), and then import it to another environment. 

Also includes a set of functions for changing parts of a content model. 

**contentful_api_real.rb** is a framework for whatever creation or change methods I want to run. Specify the changes at the end of this then run it. 

**contentful_functions.rb** is a set of methods for adding, removing and changing types and fields.

**transform_export.rb** is makes changes to the exported content model and resaves it to a new json file. At the moment all it does is delete content types that aren't yet ready for the master environment. 

**type_migration.template** is a bash script template that environment ids adding. Then rename it to .command and run it. It will export, transform and import. 


## How Contentful content models fit together
A content model contains a number of content types. 

Each type has some data associated with it - a name, an id and so on. It also has a set of fields. You need to define these fields in advance as field objects. 

Each field object has a set of attributes that define the field. 

In the Contentful web app, each field has an 'appearance' tab that defines how that field works in the web app. This appearance tab is *not* defined in the field object. Instead, each content type has an array called editor_interface that specifies the appearance details to use for each field