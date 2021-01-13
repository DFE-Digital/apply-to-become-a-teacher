require 'rails_helper'

RSpec.describe CreateInterview do
  include CourseOptionHelpers

  let(:application_choice) { create(:application_choice, :awaiting_provider_decision, course_option: course_option) }
  let(:course_option) { course_option_for_provider(provider: provider) }
  let(:provider) { create(:provider) }
  let(:provider_user) { create(:provider_user, :with_make_decisions, providers: [provider]) }
  let(:service_params) do
    {
      actor: provider_user,
      application_choice: application_choice,
      provider: provider,
      date_and_time: Time.zone.now,
      location: 'Zoom call',
      additional_details: '',
    }
  end

  describe '#save!' do
    it 'transitions the application_choice state to `interviewing` if successful' do
      service = CreateInterview.new(service_params)

      expect { service.save! }.to change { application_choice.status }.to('interviewing')
    end

    it 'creates an audit entry', with_audited: true do
      CreateInterview.new(service_params).save!

      associated_audit = application_choice.associated_audits.first
      expect(associated_audit.auditable).to eq(application_choice.interviews.first)
      expect(associated_audit.audited_changes.keys).to eq(%w[
        location provider_id date_and_time additional_details application_choice_id
      ])
      expect(associated_audit.audited_changes['location']).to eq('Zoom call')
    end
  end
end