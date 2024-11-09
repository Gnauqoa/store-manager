# frozen_string_literal: true

module V1
  module Users
    class Orders < Base
      resources :orders do

        desc 'Get all orders',
              summary: 'Get all orders'
        params do
          optional :customer_id, type: Integer, desc: 'Search order by customer ID'
          optional :max_total_amount, type: Integer, desc: 'Search order by max total price'
          optional :min_total_amount, type: Integer, desc: 'Search order by min total price'
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number'
        end
        get do
          orders = Order.all
          orders = orders.where(customer_id: params[:customer_id]) if params[:customer_id].present?
          orders = orders.where('total_amount <= ?', params[:max_total_amount]) if params[:max_total_amount].present?
          orders = orders.where('total_amount >= ?', params[:min_total_amount]) if params[:min_total_amount].present?
          
          paginated_response(orders)

          rescue StandardError => e
            error!(e.message, 400)
        end
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
