  # ENUM fields declarations (starts with 0 zero)
class Event < ActiveRecord::Base
  enum scope: { 
    private: 'Private',
    public: 'Public'
  }
end