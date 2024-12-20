# frozen_string_literal: true

module V1
  module Users
    class Products < Base
      include Rails.application.routes.url_helpers

      resources :products do
        desc "Get upload product image signature",
             summary: "Get upload product image signature"
        get ":id/upload_image_signature" do
          product = Product.find(params[:id])

          if product.nil?
            error!("Product not found", 404)
          end

          service = V1::Cloudinary::GenerateSignature.call(
            public_id: "products/" + product.id.to_s,
          )

          format_response(service)
        end

        desc "Get all products",
             summary: "Get all products"
        params do
          optional :product_name, type: String, desc: "Search product by name"
          optional :page, type: Integer, desc: "Page number"
          optional :per_page, type: Integer, desc: "Per page number"
        end
        get do
          products = if params[:product_name].present?
              Product.joins(:category).where("products.product_name LIKE ?", "%#{params[:product_name]}%")
            else
              Product.all
            end
          paginated_response(products)
        end

        desc "Create a new product",
             summary: "Create a new product",
             consumes: ["multipart/form-data"]
        params do
          requires :product_name, type: String, desc: "Name of the product"
          requires :category_id, type: Integer, desc: "ID of the category"
          optional :status, type: String, desc: "status: active/disabled", values: %w[active disabled], default: "active"
          optional :unit, type: String, desc: "Unit of the product"
        end
        post do
          product = Product.new(
            product_name: params[:product_name],
            category_id: params[:category_id],
            status: params[:status],
            unit: params[:unit],
          )

          if product.save
            format_response(product)
          else
            error!(product.errors.full_messages, 422)
          end
        end

        desc "Get a product by ID",
             summary: "Get a product by ID"
        params do
          requires :id, type: Integer, desc: "ID of the product"
        end
        get ":id" do
          product = Product.find(params[:id])
          format_response(product)
        rescue ActiveRecord::RecordNotFound
          error!("Product not found", 404)
        end

        desc "Update a product",
             summary: "Update a product",
             consumes: ["multipart/form-data"]
        params do
          requires :id, type: Integer, desc: "ID of the product"
          optional :product_name, type: String, desc: "New name of the product"
          optional :category_id, type: Integer, desc: "ID of the category"
          optional :status, type: String, desc: "status: active/disabled", values: %w[active disabled], default: "active"
          optional :image_url, type: String, desc: "Image of the product"
          optional :unit, type: String, desc: "Unit of the product"
        end
        put ":id" do
          product = Product.find(params[:id])

          product.update(
            product_name: params[:product_name],
            category_id: params[:category_id] ? params[:category_id] : product.category_id,
            status: params[:status],
            image_url: params[:image_url],
            unit: params[:unit],
          )

          if product.save
            format_response(product)
          else
            error!(product.errors.full_messages, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!("Product not found", 404)
        end

        desc "Delete a product",
             summary: "Delete a product"
        params do
          requires :id, type: Integer, desc: "ID of the product"
        end
        delete ":id" do
          product = Product.find(params[:id])
          product.destroy
          { message: "Product deleted successfully" }
        rescue ActiveRecord::RecordNotFound
          error!("Product not found", 404)
        end
      end
    end
  end
end
