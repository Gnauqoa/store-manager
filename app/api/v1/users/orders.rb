# frozen_string_literal: true

module V1
  module Users
    class Orders < Base
      resources :orders do
        desc 'Create a new order',
             summary: 'Create a new order'
        params do
          requires :customer_id, type: Integer, desc: 'ID of the customer', allow_blank: false, example: 123
          requires :items, type: Array[JSON], desc: 'List of order items' do
            requires :batch_id, type: Integer, desc: 'Batch ID', allow_blank: false, example: 456
            requires :quantity, type: Integer, desc: 'Quantity of the product', values: ->(val) { val > 0 }, allow_blank: false, example: 2
          end
        end
        post do
          order = ::V1::Orders::Create.call(params: declared(params))
          format_response(order)
          rescue StandardError => e
            error!(e.message, 400)
          end
        end
    end
  end
end
