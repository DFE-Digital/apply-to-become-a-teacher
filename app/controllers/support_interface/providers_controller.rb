module SupportInterface
  class ProvidersController < SupportInterfaceController
    def index
      @providers = Provider.where(sync_courses: true)
        .includes(:sites, :courses, :provider_agreements)
        .order(:name)
    end

    def other_providers
      @providers = Provider.where(sync_courses: false).order(:name)
    end

    def show
      @provider = Provider.find(params[:provider_id])
      @provider_agreement = ProviderAgreement.data_sharing_agreements.for_provider(@provider).last
    end

    def courses
      @provider = Provider.includes(courses: [:accredited_provider]).find(params[:provider_id])
      @courses = @provider.courses.includes(accredited_provider: [:provider_agreements]).order(:name).group_by(&:recruitment_cycle_year)
    end

    def ratified_courses
      @provider = Provider.includes(courses: [:accredited_provider]).find(params[:provider_id])
      @ratified_courses = @provider.accredited_courses.includes(:provider, accredited_provider: [:provider_agreements]).order(:name).group_by(&:recruitment_cycle_year)
    end

    def vacancies
      @provider = Provider.find(params[:provider_id])
      @course_options = @provider.course_options.includes(:course, :site)
    end

    def users
      @provider = Provider.includes(:provider_users).find(params[:provider_id])
      @relationship_diagram = SupportInterface::ProviderRelationshipsDiagram.new(provider: @provider)
    end

    def applications
      @provider = Provider.find(params[:provider_id])
    end

    def sites
      @provider = Provider.includes(:courses, :sites).find(params[:provider_id])
    end

    def history
      @provider = Provider.find(params[:provider_id])
    end

    def open_all_courses
      update_provider('Successfully updated all courses') { |provider| OpenProviderCourses.new(provider: provider).call }
    end

    def enable_course_syncing
      update_provider('Successfully updated provider') { |provider| provider.update!(sync_courses: true) }
    end

  private

    def update_provider(success_message)
      @provider = Provider.find(params[:provider_id])

      yield @provider

      flash[:success] = success_message
      redirect_to support_interface_provider_courses_path(@provider)
    end
  end
end
