require 'rails_helper'

RSpec.describe CandidateInterface::ContactDetailsReviewComponent do
  let(:application_form) do
    build_stubbed(
      :application_form,
      phone_number: '07700 900 982',
      address_line1: '42',
      address_line2: 'Much Wow Street',
      address_line3: 'London',
      address_line4: 'England',
      postcode: 'SW1P 3BT',
    )
  end

  context 'when contact details are editable' do
    it 'renders component with correct values for a phone number' do
      result = render_inline(described_class.new(application_form: application_form))

      expect(result.css('.govuk-summary-list__key').text).to include(t('application_form.contact_details.phone_number.label'))
      expect(result.css('.govuk-summary-list__value').text).to include('07700 900 982')
      expect(result.css('.govuk-summary-list__actions a')[0].attr('href')).to include(Rails.application.routes.url_helpers.candidate_interface_edit_phone_number_path)
      expect(result.css('.govuk-summary-list__actions').text).to include("Change #{t('application_form.contact_details.phone_number.change_action')}")
    end

    context 'when contact details are completed' do
      it 'renders component with correct values for a UK address' do
        result = render_inline(described_class.new(application_form: application_form))

        expect(result.css('.govuk-summary-list__key').text).to include(t('application_form.contact_details.full_address.label'))
        expect(result.css('.govuk-summary-list__value').to_html).to include('42<br>Much Wow Street<br>London<br>England<br>SW1P 3BT')
        expect(result.css('.govuk-summary-list__actions a')[1].attr('href')).to include(Rails.application.routes.url_helpers.candidate_interface_edit_address_type_path)
        expect(result.css('.govuk-summary-list__actions').text).to include("Change #{t('application_form.contact_details.full_address.change_action')}")
      end

      it 'renders component with correct values for an international address' do
        application_form = build_stubbed(
          :application_form,
          phone_number: '+91 1234567890',
          address_type: 'international',
          address_line1: '321 MG Road',
          address_line3: 'Mumbai',
          country: 'IN',
        )
        result = render_inline(described_class.new(application_form: application_form))

        expect(result.css('.govuk-summary-list__key').text).to include(t('application_form.contact_details.full_address.label'))
        expect(result.css('.govuk-summary-list__value').to_html).to include('321 MG Road<br>Mumbai<br>India')
        expect(result.css('.govuk-summary-list__actions a')[1].attr('href')).to include(Rails.application.routes.url_helpers.candidate_interface_edit_address_type_path)
        expect(result.css('.govuk-summary-list__actions').text).to include("Change #{t('application_form.contact_details.full_address.change_action')}")
      end
    end

    it 'renders the address fields that are not empty strings' do
      application_form = build(
        :application_form,
        phone_number: '07700 900 982',
        address_line1: '42 <script>Much</script> Wow Street',
        address_line2: '',
        address_line3: 'London',
        address_line4: 'England',
        postcode: 'SW1P 3BT',
      )

      result = render_inline(described_class.new(application_form: application_form))

      expect(result.css('.govuk-summary-list__value').to_html).to include('42 &lt;script&gt;Much&lt;/script&gt; Wow Street<br>London<br>England<br>SW1P 3BT')
    end
  end

  context 'when contact details are not editable' do
    it 'renders component without an edit link' do
      result = render_inline(described_class.new(application_form: application_form, editable: false))

      expect(result.css('.app-summary-list__actions').text).not_to include('Change')
    end
  end
end
