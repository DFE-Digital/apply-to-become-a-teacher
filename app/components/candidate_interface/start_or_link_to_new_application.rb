module CandidateInterface
  class StartOrLinkToNewApplication < ViewComponent::Base
    include ViewHelper
    attr_reader :candidate

    def initialize(candidate:)
      @candidate = candidate
    end

    def title
      @candidate.current_application.draft? ? 'View your current application form' : 'Would you like to apply to another course?'
    end
  end
end
