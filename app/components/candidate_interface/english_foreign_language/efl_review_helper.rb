module CandidateInterface
  module EnglishForeignLanguage
    module EflReviewHelper
      def do_you_have_a_qualification_row(value:)
        {
          key: 'Have you done an English as a foreign language assessment?',
          value: value,
          action: {
            href: candidate_interface_english_foreign_language_edit_start_path,
            visually_hidden_text: 'whether or not you have a qualification',
          },
        }
      end

      def type_of_qualification_row(name:)
        {
          key: 'Type of assessment',
          value: name,
          action: {
            href: candidate_interface_english_foreign_language_type_path,
          },
        }
      end
    end
  end
end
