module ProviderInterface
  class ProviderApplicationsPageState
    attr_accessor :available_filters, :filter_selections, :provider_user
    attr_reader :applied_filters

    STATE_STORE_KEY = :provider_interface_applications_page_state

    def initialize(params:, provider_user:, state_store:)
      @provider_user = provider_user
      @applied_filters = parse_params(params)
      @state_store = state_store

      if @applied_filters.empty?
        @applied_filters = last_saved_filter_state
      else
        save_filter_state!
      end
    end

    def filters
      ([] << search_filter << recruitment_cycle_filter << status_filter << provider_filter << accredited_provider_filter).concat(provider_locations_filters).compact
    end

    def filtered?
      applied_filters.values.any?
    end

    def sort_by
      sort_options.map(&:last).flatten.include?(applied_filters[:sort_by]) ? applied_filters[:sort_by] : 'last_changed'
    end

    def sort_options
      [['Last changed', 'last_changed'], ['Days left to respond', 'days_left_to_respond']]
    end

  private

    def parse_params(params)
      params.permit(:candidate_name, :sort_by, recruitment_cycle_year: [], provider: [], status: [], accredited_provider: [], provider_location: []).to_h
    end

    def save_filter_state!
      @state_store[STATE_STORE_KEY] = @applied_filters.to_json
    end

    def last_saved_filter_state
      JSON.parse(@state_store[STATE_STORE_KEY] || '{}').with_indifferent_access
    end

    def search_filter
      {
        type: :search,
        heading: 'Candidate’s name',
        value: applied_filters[:candidate_name],
        name: 'candidate_name',
      }
    end

    def recruitment_cycle_filter
      current_year = RecruitmentCycle.current_year
      previous_year = RecruitmentCycle.previous_year

      label = {
        current_year => "#{current_year} to #{current_year + 1} (Current)",
        previous_year => "#{previous_year} to #{previous_year + 1}",
      }

      cycle_options = [current_year, previous_year].map do |year|
        {
          value: year,
          label: label[year],
          checked: applied_filters[:recruitment_cycle_year]&.include?(year.to_s),
        }
      end

      {
        type: :checkboxes,
        heading: 'Cycle',
        name: 'recruitment_cycle_year',
        options: cycle_options,
      }
    end

    def status_filter
      status_options = %w[
        awaiting_provider_decision
        offer
        pending_conditions
        recruited
        enrolled
        rejected
        declined
        withdrawn
        conditions_not_met
        offer_withdrawn
      ].map do |state_name|
        {
          value: state_name,
          label: I18n.t!("provider_application_states.#{state_name}"),
          checked: applied_filters[:status]&.include?(state_name),
        }
      end

      {
        type: :checkboxes,
        heading: 'Status',
        name: 'status',
        options: status_options,
      }
    end

    def provider_filter
      providers = ProviderOptionsService.new(provider_user).providers

      return nil if providers.size < 2

      provider_options = providers.map do |provider|
        {
          value: provider.id,
          label: provider.name,
          checked: applied_filters[:provider]&.include?(provider.id.to_s),
        }
      end

      {
        type: :checkboxes,
        heading: 'Provider',
        name: 'provider',
        options: provider_options,
      }
    end

    def accredited_provider_filter
      accredited_providers = ProviderOptionsService.new(provider_user).accredited_providers

      return nil if accredited_providers.empty?

      accredited_providers_options = accredited_providers.map do |accredited_provider|
        {
          value: accredited_provider.id,
          label: accredited_provider.name,
          checked: applied_filters[:accredited_provider]&.include?(accredited_provider.id.to_s),
        }
      end

      {
        type: :checkboxes,
        heading: 'Accredited provider',
        name: 'accredited_provider',
        options: accredited_providers_options,
      }
    end

    def provider_locations_filters
      return [] if applied_filters[:provider].nil?

      providers = ProviderOptionsService.new(provider_user).providers_with_sites(provider_ids: applied_filters[:provider])

      providers.map do |p|
        next unless p.sites.count > 1

        {
          type: :checkboxes,
          heading: "Locations for #{p.name}",
          name: 'provider_location',
          options: p.sites.map do |s|
            {
              value: s.id,
              label: s.name,
              checked: applied_filters[:provider_location]&.include?(s.id.to_s),
            }
          end,
        }
      end
    end
  end
end
