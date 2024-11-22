# frozen_string_literal: true
module V1
  module PointTransactions
    class Create < ServiceBase
      def initialize(params)
        @customer_id = params[:customer_id]
        @point_amount = params[:point_amount]
        @description = params[:description]
        @created_by_id = params[:created_by_id]
      end

      def call
        create_point_transaction
      end

      private

      attr_reader :customer_id, :point_amount, :description, :created_by_id

      def create_point_transaction
        ActiveRecord::Base.transaction do
          # Tạo point_transaction
          point_transaction = PointTransaction.create!(
            customer_id:,
            points: point_amount,
            transaction_type: point_amount > 0 ? :credit : :debit,
            description:,
            created_by_id: created_by_id
          )

          # Cập nhật số điểm của user
          customer = Customer.find(customer_id)
          customer.update!(points: customer.points + point_amount)

          point_transaction
        end
      end
    end
  end
end