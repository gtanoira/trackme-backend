class CustomerOrderEvent < OrderEvent
  belongs_to :customer_order
end
