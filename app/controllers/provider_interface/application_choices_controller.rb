module ProviderInterface
  class ApplicationChoicesController < ProviderInterfaceController
    def index
      @sort_order = params[:sort_order].eql?('asc') ? 'asc' : 'desc'
      @sort_by = params[:sort_by].presence || 'last-updated'
      @filter_visible = params['filter_visible'] ||= 'true'

      @filter_options = extract_filter_options(params: params)


      application_choices = GetApplicationChoicesForProviders.call(providers: current_provider_user.providers)
        .order(ordering_arguments(@sort_by, @sort_order))

      filtered_application_choices = FilterApplicationChoicesForProviders.call(application_choices: application_choices, filter_options: @filter_options)

      @application_choices = filtered_application_choices
    end

    def show
      @application_choice = GetApplicationChoicesForProviders.call(providers: current_provider_user.providers)
        .find(params[:application_choice_id])
    end

  private

    def ordering_arguments(sort_by, sort_order)
      {
        'course' => { 'courses.name' => sort_order },
        'last-updated' => { 'application_choices.updated_at' => sort_order },
        'name' => { 'last_name' => sort_order, 'first_name' => sort_order },
      }[sort_by]
    end

    def extract_filter_options(params:)
      params.fetch('filter', false) ? params['filter']['status'].keys : []
    end
  end
end
