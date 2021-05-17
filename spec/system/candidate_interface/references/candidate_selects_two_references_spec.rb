require 'rails_helper'

RSpec.feature 'Candidate selects two references of many feedback_provided references' do
  include CandidateHelper

  scenario 'the candidate has received 4 references and must select 2 before completing the section' do
    given_i_am_signed_in
    and_the_select_references_flag_is_active
    and_i_have_received_four_references

    when_i_visit_the_references_section
    then_i_see_the_option_to_select_two_references_and_complete_the_section

    when_i_choose_yes
    and_click_continue
    then_i_see_the_select_references_page
    and_i_see_all_my_feedback_provided_references

    when_i_click_complete_section
    then_i_am_told_i_need_to_select_two_references

    when_i_select_3_references
    and_click_continue
    then_i_am_told_i_need_to_select_two_references

    when_i_select_2_references
    and_click_continue
    then_i_see_the_application_form_page
    and_the_references_section_is_complete

    when_i_visit_the_references_section
    then_i_can_see_that_i_have_selected_two_references
  end

  def given_i_am_signed_in
    @candidate = create(:candidate)
    login_as(@candidate)
    @application = @candidate.current_application
  end

  def and_the_select_references_flag_is_active
    FeatureFlag.activate('select_references')
  end

  def and_i_have_received_four_references
    create_list(:reference, 4, feedback_status: :feedback_provided, application_form: @application)
  end

  def when_i_visit_the_references_section
    visit candidate_interface_references_review_path
  end

  def then_i_see_the_option_to_select_two_references_and_complete_the_section
    expect(page).to have_content 'Do you want complete this section?'
  end

  def when_i_choose_yes
    choose 'Yes, I will select 2 references'
  end

  def and_click_continue
    click_button 'Continue'
  end

  def then_i_see_the_select_references_page
    expect(page).to have_current_path candidate_interface_select_references_path
  end

  def and_i_see_all_my_feedback_provided_references
    provided_references = @application.application_references.feedback_provided
    @first_reference = provided_references.first
    @second_reference = provided_references.second
    @third_reference = provided_references.third
    @fourth_reference = provided_references.fourth

    expect(page).to have_checked_field("#{@first_reference.name} – #{@first_reference.referee_type}")
    expect(page).to have_checked_field("#{@second_reference.name} – #{@second_reference.referee_type}")
    expect(page).to have_checked_field("#{@third_reference.name} – #{@third_reference.referee_type}")
    expect(page).to have_checked_field("#{@fourth_reference.name} – #{@fourth_reference.referee_type}")
  end

  def then_i_am_told_i_need_to_select_two_references
    expect_validation_error 'Choose two references to complete the section'
  end

  def when_i_select_3_references
    check "#{@first_reference.name} – #{@first_reference.referee_type}"
    check "#{@second_reference.name} – #{@second_reference.referee_type}"
    check "#{@third_reference.name} – #{@third_reference.referee_type}"
  end

  def when_i_select_2_references
    uncheck "#{@third_reference.name} – #{@third_reference.referee_type}"
  end

  def then_i_see_the_application_form_page
    expect(page).to have_current_path(candidate_interface_application_form_path)
  end

  def and_the_references_section_is_complete
    expect(page).to have_css('#references-badge-id', text: 'Completed')
  end

  def then_i_can_see_that_i_have_selected_two_references
    within all('.app-summary-card'[0]) do
      expect(page).to have_content @first_reference.name
      expect(page).to have_content 'REFERENCE SELECTED'
    end

    within all('.app-summary-card'[1]) do
      expect(page).to have_content @second_reference.name
      expect(page).to have_content 'REFERENCE SELECTED'
    end
  end

  def and_two_references_with_feedback_provided
    within all('.app-summary-card'[2]) do
      expect(page).to have_content @third_reference.name
      expect(page).to have_content 'REFERENCE GIVEN'
    end

    within all('.app-summary-card'[3]) do
      expect(page).to have_content @fourth_reference.name
      expect(page).to have_content 'REFERENCE GIVEN'
    end
  end
end
