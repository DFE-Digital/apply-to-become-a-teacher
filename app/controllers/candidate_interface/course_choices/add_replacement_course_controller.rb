module CandidateInterface
  module CourseChoices
    class AddReplacementCourseController < CandidateInterfaceController
      def new
        @form = AddReplacementCourseForm.new
      end

      def create
        course_option = CourseOption.find(replacement_params.fetch(:course_option_id))
        SupportInterface::AddCourseChoiceAfterSubmission.new(application_form: current_application, course_option: course_option).call
        redirect_to candidate_interface_application_complete_path
      end

    private

      def replacement_params
        params.require(:candidate_interface_add_replacement_course_form).permit(:course_option_id)
      end
    end
  end
end
