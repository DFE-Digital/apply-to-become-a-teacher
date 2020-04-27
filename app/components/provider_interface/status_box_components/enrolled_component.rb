module ProviderInterface
  module StatusBoxComponents
    class EnrolledComponent < ViewComponent::Base
      include ViewHelper
      attr_reader :application_choice

      def initialize(application_choice:, options: {})
        @application_choice = application_choice
        @options = options
      end

      def render?
        application_choice.enrolled? || \
          raise(ProviderInterface::StatusBoxComponent::ComponentMismatchError)
      end

      def rows
        [
          {
            key: 'Enrolled',
            value: application_choice.enrolled_at.to_s(:govuk_date),
          },
          {
            key: 'Provider',
            value: application_choice.offered_course.provider.name,
          },
          {
            key: 'Course',
            value: application_choice.offered_course.name_and_code,
          },
          {
            key: 'Location',
            value: application_choice.offered_site.name_and_address,
          },
        ]
      end
    end
  end
end
