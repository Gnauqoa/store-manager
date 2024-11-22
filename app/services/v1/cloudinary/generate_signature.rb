module V1
  module Cloudinary
    class GenerateSignature < ServiceBase
      def initialize(params)
        @params = params
      end

      def call
        generate_signature
      end

      private

      attr_reader :params

      def generate_signature
        timestamp = (Time.now - 0.5.hour).to_i
        params_to_sign = params.merge(timestamp: timestamp)
        # Sort parameters alphabetically and create the signature string
   
        # Generate the signature using the API secret
        api_secret = ENV['CLOUDINARY_API_SECRET']
        signature = ::Cloudinary::Utils.api_sign_request(params_to_sign, api_secret)

        {
          signature: signature,
          timestamp: timestamp,
          api_key: ENV['CLOUDINARY_API_KEY'],
          public_id: params[:public_id],
          cloud_name: ENV['CLOUDINARY_CLOUD_NAME']
        }
      end
    end
  end
end