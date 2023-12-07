class Rack::Tracker::Cordial < Rack::Tracker::Handler
  class Event < OpenStruct
    def write
      meta_data = action_name.present? ? action_name_to_json : ""
      properties.present?  ? meta_data << properties_to_json : meta_data
    end

    def action_name_to_json
      "#{action_name.to_json}, "
    end

    def properties_to_json
      # TODO: Set this up so we can pass in JavaScript variable names
      # Currently, we can only pass in strings since we're using to_json
      # Ex: crdl("event", "NPSSubmit", {"cookie_id":"8ded0052-4668-4b57-9e14-bd8501678f92","email":null,"first_name":null,"rating":"e.detail.recommendation_rating.value"});
      props = properties.to_json
    end
  end

  class Connect < Event
    def name
      'connect'
    end
  end

  class Contact < Event
    def name
      'contact'
    end
  end

  class CustomEvent < Event
    def name
      'event'
    end
  end
end
