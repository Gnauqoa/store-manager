# frozen_string_literal: true

module V1
  module Users
    class Batches < Base
      resources :batches do
        desc 'Get all batches',
             summary: 'Get all batches'
        params do
          optional :search, type: String, desc: 'Search batch by batch number'
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number'
        end
        get do
          batches = if params[:search].present?
                      Batch.where('batch_number LIKE ?', "%#{params[:search]}%")
                    else
                      Batch.all
                    end
          paginated_response(batches)
        end

        desc 'Create a new batch',
             summary: 'Create a new batch'
        params do
          requires :product_id, type: Integer, desc: 'ID of the product'
          requires :batch_number, type: String, desc: 'Batch number'
          requires :quantity, type: Integer, desc: 'Quantity in the batch'
          requires :price, type: BigDecimal, desc: 'Price of the batch'
          requires :expiration_date, type: DateTime, desc: 'Expiration date'
          requires :manufacture_date, type: DateTime, desc: 'Manufacture date'
        end
        post do
          if params[:quantity] <= 0
            error!('Quantity must be greater than 0', 400)
          end

          batch = Batch.new(
            product_id: params[:product_id],
            batch_number: params[:batch_number],
            quantity: params[:quantity],
            price: params[:price],
            expiration_date: params[:expiration_date],
            manufacture_date: params[:manufacture_date]
          )

          if batch.save
            product = Product.find(params[:product_id])
            new_stock_quantity = product.stockQuantity + params[:quantity]
            product.update(stockQuantity: new_stock_quantity)

            format_response(batch)
          else
            error!(batch.errors.full_messages, 422)
          end
        end

        desc 'Get a batch by ID',
             summary: 'Get a batch by ID'
        params do
          requires :id, type: Integer, desc: 'ID of the batch'
        end

        get ':id' do
          batch = Batch.find(params[:id])
          format_response(batch)
        rescue ActiveRecord::RecordNotFound
          error!('Batch not found', 404)
        end

        desc 'Update a batch',
             summary: 'Update a batch'
        params do
          requires :id, type: Integer, desc: 'ID of the batch'
          requires :product_id, type: Integer, desc: 'ID of the product'
          requires :batch_number, type: String, desc: 'Batch number'
          optional :quantity, type: Integer, desc: 'Quantity in the batch'
          optional :price, type: BigDecimal, desc: 'Price of the batch'
          optional :expiration_date, type: DateTime, desc: 'Expiration date'
          optional :manufacture_date, type: DateTime, desc: 'Manufacture date'
        end
        put ':id' do
          batch = Batch.find(params[:id])
          if batch.update(
            product_id: params[:product_id],
            batch_number: params[:batch_number],
            quantity: params[:quantity],
            price: params[:price],
            expiration_date: params[:expiration_date],
            manufacture_date: params[:manufacture_date]
          )
            format_response(batch)
          else
            error!(batch.errors.full_messages, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!('Batch not found', 404)
        end

        desc 'Delete a batch',
             summary: 'Delete a batch'
        params do
          requires :id, type: Integer, desc: 'ID of the batch'
        end
        delete ':id' do
          batch = Batch.find(params[:id])
          batch.destroy
          { message: 'Batch deleted successfully' }
        rescue ActiveRecord::RecordNotFound
          error!('Batch not found', 404)
        end
      end
    end
  end
end
