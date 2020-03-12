require 'json'
require 'faraday'
require 'contentful/management'

@PUBLIC_ADVICE = IO.read("/Users/alec/Python/KEYS/contentful_pa.txt").strip()
@environment = 'content_playground' # content_playground, dev, qa, master

KEY = IO.read("/Users/alec/Python/KEYS/contentful_manage.txt").strip() # management API key

# Run this to use the Contentful management API gem
# But I find it so buggy it's more trouble than it's worth
# Main problem is it can't save change to content types that have rich text fields
def init_gem_api()
    @client = Contentful::Management::Client.new(KEY)
    @env = @client.environments(@PUBLIC_ADVICE).find(@environment)
    puts "Contentful management API running on #{@env.name}"
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
  
def omit_field(content_type_id, field_id)
    # CAN'T GET PUT TO WORK - won't authorise, even though get does
    # From there I'll need to work out what parameter to send the content type back as
    get_url = "https://api.contentful.com/spaces/#{@PUBLIC_ADVICE}/environments/#{@environment}/content_types/#{content_type_id}"
    response = Faraday.get(get_url, {access_token: KEY})
    content = JSON.parse(response.body)
    version = content['sys']['version'].to_s
    to_omit = content['fields'].select {|t| t['id'] == field_id}[0]
    to_omit['omitted'] = true
    put_url = "https://api.contentful.com/spaces/#{@PUBLIC_ADVICE}/environments/#{@environment}/content_types/#{content_type_id}"
    save = Faraday.put(put_url) do |req|
        req.params["access_token"] = KEY
        req.headers["Authorization"] = KEY
        req.headers['Content-Type'] = "application/vnd.contentful.management.v1+json"
        req.headers['X-Contentful-Version'] = version
        req.body = content.to_json
    end
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
