# frozen_string_literal: true

module V1
  module Users
    class ManagerUsers < Base
      namespace :users do
        desc 'Get all users', summary: 'Get all users'
        params do
          optional :page, type: Integer, desc: 'Page number'
          optional :per_page, type: Integer, desc: 'Per page number', default: 50
          optional :fullname, type: String, desc: 'Search by name or username'
        end
        get do
          items = User.all
          if params[:fullname].present?
            items = items.search_by_fullname(params[:fullname])
          end
          paginated_response(items)
        end

        desc 'Get a user by ID', summary: 'Get a user by ID'
        params do
          requires :id, type: Integer, desc: 'ID of the user'
        end
        get ':id' do
          user = User.find(params[:id])
          format_response(user)
        rescue ActiveRecord::RecordNotFound
          error!('User not found', 404)
        end

      desc 'Create User',
      summary: 'Create a user'
      params do
        optional :username, type: String, regexp: /\A[a-z0-9_]{4,16}\z/, desc: 'Username'
        requires :email, type: String, regexp: URI::MailTo::EMAIL_REGEXP,
                        desc: 'The unique login email'
        requires :password, type: String, desc: 'The login password'
        requires :first_name, type: String, desc: 'First name'
        requires :last_name, type: String, desc: 'Last name'
        requires :birth, type: Date, desc: 'Birth date'
      end
      post do
        return error!("Email already exists", 422) if User.find_by_email(params[:email])
        user_params = declared(params, include_missing: false)

        result = Create.new(
          params: user_params.except(:recaptcha_token),

        ).call

        if result.success?
          status 201
          generate_token_result = GenerateToken.new(user: result.success).call
          token = generate_token_result.success
          format_response({ access_token: token })
        else
          error!(failure_response(*result.failure), 422)
        end
      end

        desc 'Update a user', summary: 'Update a user'
        params do
          requires :id, type: Integer, desc: 'ID of the user'
          optional :email, type: String, regexp: URI::MailTo::EMAIL_REGEXP, desc: 'The unique login email'
          optional :password, type: String, desc: 'The login password'
          optional :first_name, type: String, desc: 'First name'
          optional :last_name, type: String, desc: 'Last name'
          optional :birth, type: Date, desc: 'Birth date'
          optional :role, type: String, values: User.roles.keys, desc: 'Role of the user'
        end
        put ':id' do
          user = User.find(params[:id])
          if user.update(declared(params, include_missing: false))
            format_response(user)
          else
            error!(user.errors.full_messages, 422)
          end
        rescue ActiveRecord::RecordNotFound
          error!('User not found', 404)
        end

        desc 'Delete a user', summary: 'Delete a user'
        params do
          requires :id, type: Integer, desc: 'ID of the user'
        end
        delete ':id' do
          user = User.find(params[:id])
          user.destroy
          format_response(user)
        rescue ActiveRecord::RecordNotFound
          error!('User not found', 404)
        end
      end
    end
  end
end
