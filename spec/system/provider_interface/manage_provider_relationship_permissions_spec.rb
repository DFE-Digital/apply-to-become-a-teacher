require 'rails_helper'

RSpec.feature 'Managing provider user permissions' do
  include DfESignInHelpers

  scenario 'Provider manages permissions for users' do
    given_i_am_a_provider_user_with_dfe_sign_in
    and_the_provider_permissions_feature_is_enabled
    and_the_safeguarding_declaration_feature_flag_is_active
    and_i_sign_in_to_the_provider_interface
    and_i_can_manage_organisations_for_a_provider
    and_the_provider_has_courses_ratified_by_another_provider
    and_i_am_permitted_to_view_safeguarding_information
    and_the_provider_has_an_open_application

    when_i_view_the_application
    then_i_should_not_see_the_safeguarding_declaration_section

    when_i_visit_the_edit_provider_relationship_permissions_page
    and_i_allow_my_training_provider_to_view_safeguarding_information
    then_i_am_asked_to_confirm_the_training_provider_permission_to_view_safeguarding

    when_i_confirm_the_permissions
    then_i_can_see_the_permissions_were_successfully_changed

    when_i_view_the_application
    then_i_should_see_the_safeguarding_declaration_section

    when_i_visit_the_edit_provider_relationship_permissions_page
    and_i_allow_the_ratifying_provider_to_view_safeguarding_information
    and_i_deny_my_training_provider_permission_to_view_safeguarding_information
    then_i_am_asked_to_confirm_the_ratifying_provider_permission_to_view_safeguarding

    when_i_confirm_the_permissions
    then_i_can_see_the_permissions_were_successfully_changed
  end

  def given_i_am_a_provider_user_with_dfe_sign_in
    provider_exists_in_dfe_sign_in
    provider_user_exists_in_apply_database
  end

  def and_the_provider_permissions_feature_is_enabled
    FeatureFlag.activate('enforce_provider_to_provider_permissions')
  end

  def and_the_safeguarding_declaration_feature_flag_is_active
    FeatureFlag.activate('provider_view_safeguarding')
  end

  def and_i_can_manage_organisations_for_a_provider
    # This relies on the 'manage_organisations' permission, yet to be implemented.
    @provider_user = ProviderUser.last
    @training_provider = Provider.find_by(code: 'ABC')
    @ratifying_provider = Provider.find_by(code: 'DEF')
  end

  def and_i_am_permitted_to_view_safeguarding_information
    @provider_user.provider_permissions.update_all(view_safeguarding_information: true)
  end

  def and_the_provider_has_courses_ratified_by_another_provider
    create(
      :accredited_body_permissions,
      ratifying_provider: @ratifying_provider,
      training_provider: @training_provider,
    )

    create(
      :training_provider_permissions,
      ratifying_provider: @ratifying_provider,
      training_provider: @training_provider,
    )
  end

  def and_the_provider_has_an_open_application
    @application_choice = create(
      :application_choice,
      status: :application_complete,
      course_option: create(
        :course_option,
        course: create(:course, accredited_provider_id: @ratifying_provider.id, provider_id: @training_provider.id),
      ),
      reject_by_default_at: 20.days.from_now,
      application_form: create(:application_form),
    )

    ApplicationStateChange.new(@application_choice).send_to_provider!
  end

  def when_i_view_the_application
    visit provider_interface_application_choice_path(@application_choice)
  end

  def then_i_should_not_see_the_safeguarding_declaration_section
    expect(page).not_to have_content('Criminal convictions and professional misconduct')
  end

  def when_i_visit_the_edit_provider_relationship_permissions_page
    visit provider_interface_edit_provider_relationship_permissions_path(
      ratifying_provider_id: @ratifying_provider.id,
      training_provider_id: @training_provider.id,
    )
  end

  def and_i_allow_my_training_provider_to_view_safeguarding_information
    within(find('.govuk-checkboxes__item', match: :first)) do
      check 'They have access to safeguarding information'
    end

    click_on 'Continue'
  end

  def then_i_am_asked_to_confirm_the_training_provider_permission_to_view_safeguarding
    expect(page).to have_content("#{@training_provider.name} can:\nsee safeguarding information")
    expect(page).not_to have_content("#{@ratifying_provider.name} can:\nsee safeguarding information")
  end

  def when_i_confirm_the_permissions
    click_on 'Save permissions'
  end

  def then_i_can_see_the_permissions_were_successfully_changed
    expect(page).to have_content('Permissions successfully set up')
  end

  def then_i_should_see_the_safeguarding_declaration_section
    expect(page).to have_content('Criminal convictions and professional misconduct')
  end

  def and_i_allow_the_ratifying_provider_to_view_safeguarding_information
    within(all('.govuk-checkboxes__item').last) do
      check 'They have access to safeguarding information'
    end
  end

  def and_i_deny_my_training_provider_permission_to_view_safeguarding_information
    within(find('.govuk-checkboxes__item', match: :first)) do
      uncheck 'They have access to safeguarding information'
    end

    click_on 'Continue'
  end

  def then_i_am_asked_to_confirm_the_ratifying_provider_permission_to_view_safeguarding
    expect(page).not_to have_content("#{@training_provider.name} can:\nsee safeguarding information")
    expect(page).to have_content("#{@ratifying_provider.name} can:\nsee safeguarding information")
  end
end
