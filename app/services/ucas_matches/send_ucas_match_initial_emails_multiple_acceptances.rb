module UCASMatches
  class SendUCASMatchInitialEmailsMultipleAcceptances
    attr_reader :ucas_match

    def initialize(ucas_match)
      @ucas_match = ucas_match
    end

    def call
      raise "Initial emails for UCAS match ##{ucas_match.id} were already sent" if ucas_match.initial_emails_sent?

      CandidateMailer.ucas_match_initial_email_multiple_acceptances(ucas_match.candidate).deliver_later
    end
  end
end
