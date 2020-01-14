import contentful_management
import re

from pathlib import Path

key_dir = Path(__file__).resolve().parent.parent.joinpath('KEYS')
KEY = key_dir.joinpath('contentful.txt').read_text()

client = contentful_management.Client(KEY)
space = client.spaces().all()[2].id
ENV = client.environments(space).find('master')

types = ENV.content_types().all()

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

#%%
current = get_existing(ENV, 'adviceCollection', 'versionInformation')
print(current)

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