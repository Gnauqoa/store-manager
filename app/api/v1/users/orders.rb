# frozen_string_literal: true

module V1
  module Users
    class Orders < Base
      resources :orders do
        desc 'Create a new order',
             summary: 'Create a new order'
        params do
          requires :user_id, type: Integer, desc: 'ID of the customer'
          requires :items, type: Array do
            requires :batch_id, type: Integer, desc: 'Batch ID'
            requires :quantity, type: Integer, desc: 'Quantity of the product', values: ->(val) { val > 0 }
          end
        end
        post do
          begin
            order = ::V1::Orders::Create.call(params: declared(params))
            
            format_response(order)
          rescue StandardError => e
            error!(e.message, 400)
          end
        end
      end
    end
  end
end
