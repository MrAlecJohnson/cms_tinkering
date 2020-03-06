require 'contentful/management'

# INCOMPLETE but I want to move to this to remove repetition
def change_field_in_all_types(data, field_id, &block)
    new_data = {
        contentTypes: [],
    }

    data['contentTypes'].each do |t|
        type_id = t['sys']['id']
        fields = t['fields']
        fields.each do |f| 
            if f['id'] == field_id
                yield
            end
        end
    end

    return new_data
end
  

def delete_all_types_and_entries(target_space, target_env)
    client = Contentful::Management::Client.new(KEY)
    env = client.environments(target_space).find(target_env)
    existing = env.entries.all
    existing.each do |entry|
        entry.unpublish
        entry.destroy
    end

    current_types = env.content_types.all.map { |t| t.id }
    current_types.each do |t|  
        target = env.content_types.find(t)
        target.deactivate
        target.destroy
    end
end
