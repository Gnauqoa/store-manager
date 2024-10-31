# frozen_string_literal: true
module V1
  module Orders
    class Create < ServiceBase
      def initialize(params:)
        @params = params
      end

      def call
        create_order
      end

      private

      attr_reader :params

      def create_order
        ActiveRecord::Base.transaction do
          # Lấy thông tin từ params
          user_id = params[:user_id]
          items = params[:items]

          # Tạo order
          order = Order.create(
            customer_id: user_id,
            total_amount: 0, # Tạm thời
            order_date: Time.now
          )


    
          total_amount = 0
    
          # Duyệt qua từng item trong order
          items.each do |item|
            batch = Batch.find(item[:batch_id])
    
            # Kiểm tra số lượng batch
            if batch.quantity < item[:quantity]
              raise "Batch with id #{item[:batch_id]} does not have enough quantity"
            end
    
            # Cập nhật lại số lượng của batch
            new_batch_quantity = batch.quantity - item[:quantity]
            batch.update!(quantity: new_batch_quantity)
    
            # Tìm sản phẩm tương ứng và cập nhật số lượng sản phẩm tổng
            product = Product.find(batch.product_id)
            new_product_stock_quantity = product.stockQuantity - item[:quantity]
            product.update!(stockQuantity: new_product_stock_quantity)
    
            # Tính tổng tiền
            total_amount += batch.price * item[:quantity]
    
            # Tạo order_item
            OrderItem.create!(
              order_id: order.id,
              batch_id: batch.id,
              quantity: item[:quantity],
              created_at: Time.now,
              updated_at: Time.now
            )
          end
    
          # Cập nhật tổng tiền cho order
          order.update!(total_amount: total_amount)
          puts order.inspect
          return order
        rescue StandardError => e
          raise ActiveRecord::Rollback, e.message
        end
      end
    end
  end
end
