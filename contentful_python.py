import contentful_management

with open(r'C:\Users\aleci\Python\KEYS\contentful.txt', 'r') as file:
    KEY = file.readline()

CLIENT = contentful_management.Client(KEY)
SPACE = CLIENT.spaces().all()[2].id
ENVIRONMENT = CLIENT.environments(SPACE).find('master')

types = ENVIRONMENT.content_types().all()

print([t.id for t in types])

#%%
pages = ['adviceCollection', 
         'adviceCollectionAdviser', 
         'adviceList']

units = ['adviceUnit', 
         'adviceUnitAdviser',
         'callout',
         'calloutAdviser', 
         'circumstantialUnit',
         'circumstantialUnitAdviser']

dynamic = ['banner', 
           'table',
           'adviserWarning',
           'amount',
           'footer',
           'callCosts',
           'contactDetails',
           'contentPattern',
           'legislationLink']

tools = ['tool', 
         'resultPage',
         'question',
         'answer']

metadata = ['topic']

#%%
def add_field(env, content_type, field, appearance):
    """Add a new field to a given content type.
    Pass the field as a dictionary including at least id and name.
    Appearance should be a separate dict for the 'controls'
    of the editor_interface object
    """
    t = env.content_types().find(content_type)
    t.fields.append(contentful_management.ContentTypeField(field))
    t.save()
    interface = t.editor_interfaces().find()
    for f in interface.controls:
        if f['fieldId'] == field['id']:
            f['settings'] = appearance
    interface.save()
    return 0


task_list = {'id': 'startTaskList',
             'name': 'Start of task list?',
             'type': 'Boolean',
             'required': True,
             }
settings = {'trueLabel': 'Yes',
            'falseLabel': 'No'}
add_field(ENVIRONMENT, 'adviceCollection', task_list, settings)

#%%
add_field(ENVIRONMENT, 'adviceCollectionAdviser', task_list, settings)
add_field(ENVIRONMENT, 'adviceList', task_list, settings)
