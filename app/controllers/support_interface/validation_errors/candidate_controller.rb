module SupportInterface
  module ValidationErrors
    class CandidateController < SupportInterface::ValidationErrors::UserController
      before_action :set_user_type

      def service_scope
        :apply
      end

    private

      def set_user_type
        @user_type = :candidate
      end
    end
  end
end
