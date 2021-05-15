class BackfillSelectedBooleanForFeedbackProvidedReferences < ActiveRecord::Migration[6.1]
  def change
    ApplicationReference.feedback_provided.update_all(selected: true)
  end
end
