module CandidateInterface
  class PreviousApplicationsComponent < ViewComponent::Base
    include ViewHelper

    def initialize(candidate:)
      @candidate = candidate
    end

    def render?
      application_choices.present?
    end

    def application_choices
      (eligible_application_choices)
        .compact
        .sort_by(&:id)
        .reverse
    end

    def provider_name_for(application_choice)
      application_choice
        .provider
        .name
    end

    def course_name_and_code_for(application_choice)
      application_choice.course.name
    end

  private

    def eligible_application_choices
      @candidate.application_forms.map(&:application_choices).flatten.select { |ac| ApplicationStateChange::UNSUCCESSFUL_END_STATES.include?(ac.status.to_sym) }
    end
  end
end
