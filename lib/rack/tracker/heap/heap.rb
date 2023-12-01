class Rack::Tracker::Heap < Rack::Tracker::Handler
  class Event < OpenStruct
    def write
      return if !options.present?
      options.to_h
    end
  end

  class Identify < Event
    def name
      'identify'
    end

    def write
      "#{id.to_s}"
    end
  end

  class AddUserProperties < Event
    def name
      'addUserProperties'
    end
  end

  class AddEventProperties < Event
    def name
      'addEventProperties'
    end
  end
end
