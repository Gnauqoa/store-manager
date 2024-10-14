# frozen_string_literal: true

module V1
  module Users
    class Products < Base
      resources :products do
        desc 'Get all products',
             summary: 'Get all products'
        params do
          optional :search, type: String, desc: 'Search product by name'
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number'
        end
        get do
          products = if params[:search].present?
                       Product.joins(:category).where('products.product_name LIKE ?', "%#{params[:search]}%")
                     else
                       Product.all
                     end
          paginated_response(products)
        end

        desc 'Create a new product',
             summary: 'Create a new product'
        params do
          requires :product_name, type: String, desc: 'Name of the product'
          requires :category_id, type: Integer, desc: 'ID of the category'
          requires :stock_quantity, type: Integer, desc: 'Total stock quantity'
          requires :status, type: Integer, desc: 'Status of the product'
        end
        post do
          product = Product.new(
            product_name: params[:product_name],
            category_id: params[:category_id],
            stock_quantity: params[:stock_quantity],
            status: params[:status]
          )
          if product.save
            format_response(product)
          else
            error!(product.errors.full_messages, 422)
          end
        end

        desc 'Get a product by ID',
             summary: 'Get a product by ID'
        params do
          requires :id, type: Integer, desc: 'ID of the product'
        end
        get ':id' do
          product = Product.find(params[:id])
          format_response(product)
        rescue ActiveRecord::RecordNotFound
          error!('Product not found', 404)
        end

        desc 'Update a product',
             summary: 'Update a product'
        params do
          requires :id, type: Integer, desc: 'ID of the product'
          requires :product_name, type: String, desc: 'New name of the product'
          optional :category_id, type: Integer, desc: 'ID of the category'
          optional :stock_quantity, type: Integer, desc: 'Total stock quantity'
          optional :status, type: Integer, desc: 'Status of the product'
        end
        put ':id' do
          product = Product.find(params[:id])
          if product.update(
            product_name: params[:product_name],
            category_id: params[:category_id],
            stock_quantity: params[:stock_quantity],
            status: params[:status]
          )
            format_response(product)
          else
            error!(product.errors.full_messages, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!('Product not found', 404)
        end

        desc 'Delete a product',
             summary: 'Delete a product'
        params do
          requires :id, type: Integer, desc: 'ID of the product'
        end
        delete ':id' do
          product = Product.find(params[:id])
          product.destroy
          { message: 'Product deleted successfully' }
        rescue ActiveRecord::RecordNotFound
          error!('Product not found', 404)
        end
      end
    end
  end
end
