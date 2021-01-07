require 'rails_helper'

RSpec.feature 'Candidate content' do
  include ActionView::Helpers::DateHelper

  scenario 'Candidate views the content pages' do
    given_i_am_on_the_start_page
    when_i_click_on_accessibility
    then_i_can_see_the_accessibility_statement

    when_i_click_on_the_cookies_page
    then_i_can_see_the_cookies_page
    and_i_can_opt_in_to_tracking_website_usage

    when_i_click_on_complaints
    then_i_can_see_the_complaints_page

    when_i_click_on_the_privacy_policy
    then_i_can_see_the_privacy_policy

    when_i_click_on_the_terms_of_use
    then_i_can_see_the_terms_candidate
  end

  def given_i_am_on_the_start_page
    visit '/'
  end

  def when_i_click_on_accessibility
    within('.govuk-footer') { click_link t('layout.support_links.accessibility') }
  end

  def then_i_can_see_the_accessibility_statement
    expect(page).to have_content(t('page_titles.accessibility'))
  end

  def when_i_click_on_the_cookies_page
    within('.govuk-footer') { click_link t('layout.support_links.cookies') }
  end

  def then_i_can_see_the_cookies_page
    expect(page).to have_content(t('page_titles.cookies_candidate'))
    expect(page).to have_content('When you close your browser')
  end

  def and_i_can_opt_in_to_tracking_website_usage
    choose 'Yes, opt-in to Google Analytics cookies'
    click_on 'Save preferences'
    expect(page).to have_content('Your cookie preferences have been updated')
  end

  def when_i_click_on_complaints
    within('.govuk-footer') { click_link t('layout.support_links.complaints') }
  end

  def then_i_can_see_the_complaints_page
    expect(page).to have_content(t('page_titles.complaints'))
    expect(page).to have_content('Make a complaint about this service')
  end

  def when_i_click_on_the_privacy_policy
    within('.govuk-footer') { click_link t('layout.support_links.privacy_policy') }
  end

  def then_i_can_see_the_privacy_policy
    expect(page).to have_content(t('page_titles.privacy_policy'))
  end

  def when_i_click_on_the_terms_of_use
    within('.govuk-footer') { click_link t('layout.support_links.terms_of_use') }
  end

  def then_i_can_see_the_terms_candidate
    expect(page).to have_content(t('page_titles.terms_candidate'))
  end
end
