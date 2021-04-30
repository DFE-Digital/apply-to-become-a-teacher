class ApplyAgain
  def initialize(application_form)
    @application_form = application_form
  end

  def call
    return false if application_choices_with_accepted_states.count >= 5

    DuplicateApplication.new(@application_form, target_phase: 'apply_2')
      .duplicate
      .tap(&:mark_sections_incomplete_if_review_needed!)
  end

private

  def application_choices_with_accepted_states
    @application_form
      .candidate
      .application_forms
      .includes(application_choices: %i[course site provider current_course current_course_option interviews])
      .map(&:application_choices)
      .flatten
      .sort_by(&:id)
      .select { |ac| ac.status.to_sym.in?(ApplicationStateChange::ACCEPTED_STATES + ApplicationStateChange::INTERVIEWABLE_STATES + [:offer]) }
  end
end
