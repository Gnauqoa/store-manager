# frozen_string_literal: true
module V1
  module Orders
    class Create < ServiceBase
      def initialize(params:)
        @customer_id = params[:customer_id]
        @items = params[:items]
        @status = params[:status]
        @discount = params[:discount]
      end

      def call
        create_order
      end

      private

      attr_reader :customer_id, :items

      def create_order
        ActiveRecord::Base.transaction do
          # Lấy thông tin từ params

          # Tạo order
          order = Order.create!(
            customer_id: customer_id,
            order_date: Time.now,
            total_amount: 0,
            status:
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
            new_product_stock_quantity = product.stock_quantity - item[:quantity]
            product.update!(stock_quantity: new_product_stock_quantity)
    
            # Tính tổng tiền
            total_amount += batch.price * item[:quantity]
    
            # Tạo order_item
            OrderItem.create!(
              order_id: order.id,
              batch_id: batch.id,
              product_id: product.id,
              quantity: item[:quantity],
              price: batch.price,
              created_at: Time.now,
              updated_at: Time.now
            )
          end

          if (discount > 0) 
            if (discount > user.points)
              raise "User does not have enough points"
            else
              V1::PointTransactions::Create.call(
                customer_id: customer_id, 
                point_amount: -discount, 
                description: "Used #{discount} points for order with id #{order.id}"
              )
            end
            total_amount -= discount
          else
            V1::PointTransactions::Create.call(
              customer_id: customer_id, 
              point_amount: calculate_point(total_amount), 
              description: "Earned #{point} points from order with id #{order.id}"
            )
          end


          # Cập nhật tổng tiền cho order
          order.update!(total_amount: total_amount)
          return order
        rescue StandardError => e
          raise ActiveRecord::Rollback, e.message
        end
      end

      def calculate_point(total_amount)
        # Tính điểm cho khách hàng
        point = total_amount / 1000
        point
      end 
    end
  end
end
