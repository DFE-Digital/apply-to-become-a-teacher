class ApplyAgain
  def initialize(application_form)
    @application_form = application_form
  end

  def call
    DuplicateApplication.new(@application_form, target_phase: 'apply_2')
      .duplicate
      .tap(&:mark_sections_incomplete_if_review_needed!)
  end
end
