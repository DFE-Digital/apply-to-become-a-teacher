module CandidateInterface
  module DecoupledReferences
    class EmailAddressController < BaseController
      before_action :set_reference

      def new
        @reference_email_address_form = Reference::RefereeEmailAddressForm.new
      end

      def create
        @reference_email_address_form = Reference::RefereeEmailAddressForm.new(referee_email_address_param)
        return render :new unless @reference_email_address_form.valid?

        @reference_email_address_form.save(@reference)

        redirect_to candidate_interface_decoupled_references_relationship_path(@reference.id)
      end

      def edit
        @reference_email_address_form = Reference::RefereeEmailAddressForm.build_from_reference(@reference)
      end

      def update
        @reference_email_address_form = Reference::RefereeEmailAddressForm.new(referee_email_address_param)
        return render :edit unless @reference_email_address_form.valid?

        @reference_email_address_form.save(@reference)

        redirect_to candidate_interface_decoupled_references_review_unsubmitted_path(@reference.id)
      end

    private

      def referee_email_address_param
        params.require(:candidate_interface_reference_referee_email_address_form).permit(:email_address)
        .merge!(application_form_id: current_application.id)
      end
    end
  end
end
