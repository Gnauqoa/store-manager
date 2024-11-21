# frozen_string_literal: true

module V1
  module Users
    class Users < PublicBase
      resources :users do
        # after do
        #   user = User.find_by_email(params[:email])
        #   user ||= User.find_by(username: params[:email])

        #   log_ip(user.id, client_ip)
        # end
      
        desc 'Sign In',
            summary: 'Sign In'
        params do
          requires :account, type: String,
                          desc: 'Email or username'
          requires :password, type: String, desc: 'The login password'
        end

        post :sign_in do
          @result = SignIn.new(
            email: params[:account],
            password: params[:password],
            request: env['warden'].request
          ).call

          if @result.success?
            status 200
            format_response({ access_token: @result.success })
          else
            error!(failure_response(*@result.failure), 422)
          end
        end
      end
    end
  end
end
