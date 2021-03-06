class SatisfactionSurveyFeatureMetrics
  include ActionView::Helpers::NumberHelper

  def response_rate(
    start_time,
    end_time = Time.zone.now.end_of_day
  )
    success_count = application_forms_with_feedback(start_time, end_time).count.to_f
    fail_count = application_forms_with_no_feedback(start_time, end_time).count.to_f
    return nil if (fail_count + success_count).zero?

    success_count / (fail_count + success_count)
  end

  def positive_feedback_rate(
    start_time,
    end_time = Time.zone.now.end_of_day
  )
    feedback_count = application_forms_with_feedback(start_time, end_time).count.to_f
    return nil if feedback_count.zero?

    positive_feedback_count = application_forms_with_positive_feedback(start_time, end_time).count.to_f

    positive_feedback_count / feedback_count
  end

  def formatted_response_rate(
    start_time,
    end_time = Time.zone.now.end_of_day
  )
    format_as_percentage(response_rate(start_time, end_time))
  end

  def formatted_positive_feedback_rate(
    start_time,
    end_time = Time.zone.now.end_of_day
  )
    format_as_percentage(positive_feedback_rate(start_time, end_time))
  end

private

  def format_as_percentage(ratio)
    return 'n/a' if ratio.nil?

    percentage = number_with_precision(
      100.0 * ratio,
      precision: 1,
      strip_insignificant_zeros: true,
    )
    "#{percentage}%"
  end

  def application_forms_with_feedback(start_time, end_time)
    ApplicationForm
      .where.not(feedback_satisfaction_level: '')
      .where(
        recruitment_cycle_year: RecruitmentCycle.current_year,
        application_forms: { submitted_at: start_time..end_time },
      )
  end

  def application_forms_with_positive_feedback(start_time, end_time)
    ApplicationForm
      .where(
        feedback_satisfaction_level: %w[very_satisfied satisfied],
        recruitment_cycle_year: RecruitmentCycle.current_year,
        application_forms: { submitted_at: start_time..end_time },
      )
  end

  def application_forms_with_no_feedback(start_time, end_time)
    ApplicationForm
      .where(
        feedback_satisfaction_level: [nil, ''],
        recruitment_cycle_year: RecruitmentCycle.current_year,
        application_forms: { submitted_at: start_time..end_time },
      )
  end
end
