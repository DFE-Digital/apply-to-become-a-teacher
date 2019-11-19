module CandidateInterface
  class ApplicationFormController < CandidateInterfaceController
    before_action :redirect_to_dashboard_if_submitted, only: %i[show review]

    def show
      return redirect_to candidate_interface_application_form_path if params[:token]

      @application_form_presenter = CandidateInterface::ApplicationFormPresenter.new(current_application)
    end

    def review
      @application_form = current_application
    end

    def complete
      @application_form = current_application
    end

    def submit_show
      @further_information_form = FurtherInformationForm.new
    end

    def submit
      @further_information_form = FurtherInformationForm.new(further_information_params)

      if @further_information_form.save(current_application)
        SubmitApplication.new(current_application).call

        redirect_to candidate_interface_application_submit_success_path
      else
        render :submit_show
      end
    end

    def submit_success
      @support_reference = current_application.support_reference
    end

    def review_submitted
      @application_form = current_application
    end

  private

    def further_information_params
      params.require(:candidate_interface_further_information_form).permit(
        :further_information,
        :further_information_details,
      )
    end
  end
end
