# content_model
The goal here is to create changes to the content model in the dev environment, then once happy move them to qa and eventually production. 

Early efforts to use the Contentful management gem half worked, but it isn't possible to fully control, change or recreate rich text fields through the gem. There are also bugs in rich text field validations (open issue on their Github, but no response).

So I've switched to using the CLI tool. You'll need to have installed this and be logged in for my new scripts to work. 

**content_model_changes** contains a method for each change made to the model. Each takes a json file, makes changes, then resaves that file with all the unchanged bits deleted.

**content_model_apply_change** is the main script. Pass it a function from content_model_changes, and select dev, qa or production. It extracts the content model from the relevant environment and saves it to json. Then it applies the selected change method. Finally it imports the edited json back to the same environment. 

I considered an approach that made the changes to dev, then copied parts of the content model from dev to qa, then from qa to production. But this seemed riskier: dev might contain other content model changes that we don't want to copy over to qa or production.

**content_model_methods.rb**, full of reusable methods for making changes to the content model json files. 