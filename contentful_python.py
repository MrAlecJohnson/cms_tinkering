import contentful_management
import re

from pathlib import Path

key_dir = Path(__file__).resolve().parent.parent.joinpath('KEYS')
KEY = key_dir.joinpath('contentful.txt').read_text()

# set up Contentful environment and get list of content types as starting point
client = contentful_management.Client(KEY)
space = client.spaces().all()[2].id
ENV = client.environments(space).find('master')

all_types = ENV.content_types().all()
types = [t.id for t in all_types]

#%%
# Sublists of categorised content types
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
           'backgroundText',
           'callCosts',
           'contactDetails',
           'contentPattern',
           'legislationLink']

tools = ['tool', 
         'resultPage',
         'question',
         'answer']

metadata = ['topic', 'tag']

# Check that everything is covered in the categories
# Go no further unless leftovers and legacy are blank 
sublists = [pages, units, dynamic, tools, metadata]
everything = [item for sublist in sublists for item in sublist]
leftovers = [t for t in types if t not in everything]
legacy = [e for e in everything if e not in types]
print('leftovers:', leftovers, end = '\n')
print('legacy:', legacy)

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
            break
    interface.save()
    return 0

def get_existing(env, content_type, field_id):
    """ Gets details of an existing field so I can set up an add field"""
    t = env.content_types().find(content_type)
    id_converted = re.sub(r'(?=[A-Z])', '_', field_id).lower()
    for f in t.fields:
        if f.id == id_converted:
            result = f
            break
    interface = t.editor_interfaces().find()
    for f in interface.controls:
        if f['fieldId'] == field_id:
            appearance = f
            break
    return {'Field': result.to_json(), 'Appearance': appearance}

def copy_field(env, field_id, original_type, target_types):
    """Get existing field from original_type and copy it to list of target types"""
    start = get_existing(env, original_type, field_id)
    for t in target_types:
        add_field(env, t, start['Field'], start['Appearance'])
        print(f'Done for {t}')
    return 0

def change_field(env, content_type, field_id, key_to_change, new_key):
    """Doesn't currently work on appearance fields or ids
    """
    t = env.content_types().find(content_type)
    id_converted = re.sub(r'(?=[A-Z])', '_', field_id).lower()
    pos = 0
    for f in t.fields: 
        if f.id == id_converted:
            if key_to_change == 'id':
                new = f.to_json()
                new['id'] = new_key
                f.omitted = True
                t = t.update()
                # or do i need to find and then .publish() the content type to 'activate' it?
                t.fields.remove(f)
                #t.fields.insert(pos, contentful_management.ContentTypeField(new))
                return 0
                #content_type.fields = [ f for f in fields if not f.id == 'author' ]

            else:
                setattr(f, key_to_change, new_key)
                t.save()
                return 0
        pos += 1    
    return 1

#%%
current = get_existing(ENV, 'adviceCollection', 'versionInformation')
print(current)

temp = {'Field': {'name': 'Url',
  'id': 'url',
  'type': 'Symbol',
  'localized': False,
  'omitted': False,
  'required': True,
  'disabled': False,
  'validations': []},
 'Appearance': {'fieldId': 'url',
  'widgetId': 'slugEditor',
  'widgetNamespace': 'builtin'}}

#%%
copy_field(ENV, 'versionInformation', 'adviceCollection', ['adviceList'])

#%%
# Version info
version_info = {'name': 'Version information', 
                'id': 'versionInformation', 
                'type': 'Text', 
                'localized': False, 
                'omitted': False, 
                'required': False, 
                'disabled': False, 
                'validations': []}
appearance = {'fieldId': 'versionInformation', 
            'settings': {'helpText': "What's changed in this version of the content?"}, 
            'widgetId': 'markdown', 
            'widgetNamespace': 'builtin'}

add_field(ENV, 'adviceCollectionAdviser', version_info, appearance)
add_field(ENV, 'adviceList', version_info, appearance)


#%%
# Task lists

task_list = {'id': 'startTaskList',
             'name': 'Start of task list?',
             'type': 'Boolean',
             'required': True,
             }
settings = {'trueLabel': 'Yes',
            'falseLabel': 'No'}
add_field(ENV, 'adviceCollection', task_list, settings)
add_field(ENV, 'adviceCollectionAdviser', task_list, settings)
add_field(ENV, 'adviceList', task_list, settings)

#%%
# Timer
import time

def timer(reps, func, *args):
    start = time.perf_counter()
    for rep in range(reps):
        result = func(*args)
    finish = time.perf_counter()
    return round((finish - start) / reps, 2)

print('seconds per call for loop:', 
      timer(10, get_existing, ENV, 'adviceCollection', 'startTaskList'))