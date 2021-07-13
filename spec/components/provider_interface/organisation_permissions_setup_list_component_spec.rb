require 'rails_helper'

RSpec.describe ProviderInterface::OrganisationPermissionsSetupListComponent do
  let(:grouped_provider_names) do
    {
      'Main provider' => ['A Provider', 'B Provider'],
    }
  end
  let(:path) { '/path' }
  let(:render) do
    render_inline(
      described_class.new(
        grouped_provider_names: grouped_provider_names,
        continue_button_path: path,
      ),
    )
  end

  it 'renders the correct page title' do
    expect(render.css('h1').first.text.squish).to eq('Set up organisation permissions')
  end

  it 'renders a button with the correct path' do
    form = render.css('form').first
    expect(form.attributes['action'].value).to eq(path)
    expect(form.css('input').first.attributes['value'].value).to eq('Set up organisation permissions')
  end

  context 'when there is a single main provider' do
    it 'renders the correct intro text' do
      expect(render.css('p').first.text.squish).to eq('Candidates can now apply through GOV.UK for courses you work on with:')
    end

    it 'renders the providers in order' do
      expect(render.css('li').map(&:text)).to eq(grouped_provider_names['Main provider'])
    end

    it 'does not render the main provider name' do
      expect(render.text).not_to include('Main provider')
    end

    it 'renders the text about managing applications' do
      expect(render.css('p').last.text.squish).to eq('You cannot manage applications to these courses until you set up organisation permissions.')
    end
  end

  context 'when there are multiple main providers' do
    let(:grouped_provider_names) do
      {
        'First main provider' => ['A Provider', 'B Provider'],
        'Second main provider' => ['Other Provider', 'Another Provider'],
      }
    end

    it 'renders the correct intro text' do
      expect(render.css('p')[0].text.squish).to eq('Candidates can now apply through GOV.UK for courses you work on with partner organisations.')
    end

    it 'renders the text about managing applications' do
      expect(render.css('p')[1].text.squish).to eq('You cannot manage applications to these courses until either you or your partner organisations have set up organisation permissions.')
    end

    it 'does not renders the main provider name for each list' do
      expect(render.css('p')[2].text.squish).to eq('For First main provider, you need to set up permissions for courses you work on with:')
      expect(render.css('p')[3].text.squish).to eq('For Second main provider, you need to set up permissions for courses you work on with:')
    end

    it 'renders the providers in order' do
      expected_provider_names = grouped_provider_names.values.flatten
      expect(render.css('li').map(&:text)).to eq(expected_provider_names)
    end
  end
end
