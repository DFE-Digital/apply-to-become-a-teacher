module CandidateInterface
  class AddReplacementCourseForm
    include ActiveModel::Model

    attr_accessor :course_option_id
    validates :course_option_id, presence: true
  end
end
