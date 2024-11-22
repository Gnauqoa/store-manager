# frozen_string_literal: true
module V1
  module PointTransactions
    class Create < ServiceBase
      def initialize(params)
        @customer_id = params[:customer_id]
        @point_amount = params[:point_amount]
        @description = params[:description]
      end

      def call
        create_point_transaction
      end

      private

      attr_reader :customer_id, :point_amount, :description

      def create_point_transaction
        ActiveRecord::Base.transaction do
          # Tạo point_transaction
          point_transaction = PointTransaction.create!(
            customer_id:,
            points: point_amount,
            transaction_type: point_amount > 0 ? :credit : :debit,
            description:
          )

          # Cập nhật số điểm của user
          user = User.find(customer_id)
          user.update!(points: user.points + point_amount)

          point_transaction
        end
      end
    end
  end
end