require 'json'
require 'faraday'
require 'contentful/management'

@PUBLIC_ADVICE = IO.read("/Users/alec/Python/KEYS/contentful_pa.txt").strip()
@environment = 'content_playground' # content_playground, dev, qa, master

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key

def content_type_json(content_type_id)
    get_url = "https://api.contentful.com/spaces/#{@PUBLIC_ADVICE}/environments/#{@environment}/content_types/#{content_type_id}"
    response = Faraday.get(get_url, {access_token: KEY})
    return JSON.parse(response.body)
end

def activate_content_type(content_type_id, version)
    put_url = "https://api.contentful.com/spaces/#{@PUBLIC_ADVICE}/environments/#{@environment}/content_types/#{content_type_id}/published"
    save = Faraday.put(put_url) do |req|
        req.params["access_token"] = KEY
        req.headers['Content-Type'] = "application/vnd.contentful.management.v1+json"
        req.headers['X-Contentful-Version'] = version
    end
end

def save_content_type_json(content_type_id, json_data)
    # send the updated content type json data back to contentful 
    # contentful has its own 'Content-Type' value for interpreting json
    put_url = "https://api.contentful.com/spaces/#{@PUBLIC_ADVICE}/environments/#{@environment}/content_types/#{content_type_id}"
    version = json_data['sys']['version'].to_s
    save = Faraday.put(put_url) do |req|
        req.params["access_token"] = KEY
        #req.headers["Authorization"] = KEY
        req.headers['Content-Type'] = "application/vnd.contentful.management.v1+json"
        req.headers['X-Contentful-Version'] = version
        req.body = json_data.to_json
    end
end


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
  
def delete_field(content_type_id, field_id)
    # run this first if you want to create a field with the same name as an old one
    # it uses the content management API to 'omit' the field from its content type
    # once the field is omitted it deletes it
    content = content_type_json(content_type_id)
    # must include content type's version number as a header in the API call
    # find the relevant field and set 'omit' to true
    to_omit = content['fields'].select {|t| t['id'] == field_id}[0]
    to_omit['omitted'] = true
    save_content_type_json(content_type_id, content)

    # now get the content again and delete it
    content = content_type_json(content_type_id)
    version = content['sys']['version'].to_s 
    activate_content_type(content_type_id, version)
    content['sys']['version'] = (version.to_i + 1).to_s # increment version after activation
    to_delete = content['fields'].select {|t| t['id'] == field_id}[0]
    to_delete['deleted'] = true
    save_content_type_json(content_type_id, content)
end    

def delete_all_types_and_entries()
    existing = @env.entries.all
    existing.each do |entry|
        entry.unpublish
        entry.destroy
    end

    current_types = @env.content_types.all.map { |t| t.id }
    current_types.each do |t|  
        target = @env.content_types.find(t)
        target.deactivate
        target.destroy
    end
end
