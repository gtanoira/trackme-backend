  # ENUM fields declarations (starts with 0 zero)
class Event < ActiveRecord::Base
  enum scope: { 
    private: 'Private',
    public: 'Public'
  }
end

class Item < ActiveRecord::Base

  enum item_type: { 
    box: 'Box',
    deco: 'Deco'
  }
  enum status: { 
    onhand: 'OnHand',
    intransit: 'In Transit',
    delivered: 'Delivered',
    deleted: 'Deleted'
  }
  enum unit_length: { 
    cm: 'cm',
    inch: 'inch'
  }
  enum unit_volume: { 
    m3: 'm3',
    kg3: 'kg3'
  }
  enum unit_weight: { 
    kg: 'kg',
    pound: 'pound'
  }

end