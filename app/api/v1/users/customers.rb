# frozen_string_literal: true

module V1
  module Users
    class Customers < PublicBase
      resources :customers do
        # Lấy danh sách tất cả khách hàng
        desc 'Get all customers',
             summary: 'Get all customers'
        params do
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number'
          optional :name, type: String, desc: 'Name of the customer'
          optional :phone, type: String, desc: 'Phone number of the customer'
        end
        get do
          customers = Customer.all
          customers = customers.where('full_name LIKE ?', "%#{params[:name]}%") if params[:name].present?
          customers = customers.where(phone: params[:phone]) if params[:phone].present?

          paginated_response(customers)
        end

        # Lấy thông tin một khách hàng theo ID
        desc 'Get customer by ID',
             summary: 'Get customer by ID'
        params do
          requires :id, type: Integer, desc: 'Customer ID'
        end
        get ':id' do
          customer = Customer.find(params[:id])
          present customer
        end

        # Tạo một khách hàng mới
        desc 'Create a new customer',
             summary: 'Create a new customer'
        params do
          requires :password, type: String, desc: 'Password of the customer'
          requires :first_name, type: String, desc: 'First name of the customer'
          requires :last_name, type: String, desc: 'Last name of the customer'
          optional :status, type: Integer, desc: 'Status of the customer'
          optional :birth, type: DateTime, desc: 'Birth date of the customer'
          optional :phone, type: String, desc: 'Phone number of the customer'
        end
        post do
          customer = Customer.new(params)
          if customer.save
            status :created
            present customer
          else
            error!(customer.errors.full_messages, 422)
          end
        end

        # Cập nhật thông tin khách hàng
        desc 'Update a customer',
             summary: 'Update a customer'
        params do
          requires :id, type: Integer, desc: 'Customer ID'
          optional :email, type: String, desc: 'Email of the customer'
          optional :password, type: String, desc: 'Password of the customer'
          optional :fullName, type: String, desc: 'Full name of the customer'
          optional :status, type: Integer, desc: 'Status of the customer'
          optional :birth, type: DateTime, desc: 'Birth date of the customer'
          optional :phone, type: String, desc: 'Phone number of the customer'
        end
        put ':id' do
          customer = Customer.find(params[:id])
          if customer.update(customer_params)
            present customer
          else
            error!(customer.errors.full_messages, 422)
          end
        end

        # Xóa một khách hàng
        desc 'Delete a customer',
             summary: 'Delete a customer'
        params do
          requires :id, type: Integer, desc: 'Customer ID'
        end
        delete ':id' do
          customer = Customer.find(params[:id])
          if customer.destroy
            status :no_content
          else
            error!(customer.errors.full_messages, 422)
          end
        end
      end

      private

      # Phương thức để lấy các tham số cho khách hàng
      def customer_params
        params.permit(:email, :password, :fullName, :status, :birth, :phone)
      end
    end
  end
end
