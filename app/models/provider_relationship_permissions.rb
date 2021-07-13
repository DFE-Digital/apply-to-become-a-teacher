class ProviderRelationshipPermissions < ApplicationRecord
  belongs_to :ratifying_provider, class_name: 'Provider'
  belongs_to :training_provider, class_name: 'Provider'

  PERMISSIONS = %i[make_decisions view_safeguarding_information view_diversity_information].freeze

  validate :at_least_one_active_permission_in_pair, if: -> { setup_at.present? }
  audited associated_with: :training_provider

  def self.possible_permissions
    PERMISSIONS.flat_map do |permission|
      ["ratifying_provider_can_#{permission}", "training_provider_can_#{permission}"]
    end
  end

  def training_provider_can_view_applications_only?
    PERMISSIONS.map { |permission| send("training_provider_can_#{permission}") }.all?(false)
  end

  def ratifying_provider_can_view_applications_only?
    PERMISSIONS.map { |permission| send("ratifying_provider_can_#{permission}") }.all?(false)
  end

  PERMISSIONS.each do |name|
    define_method(name) do
      %w[training ratifying].select { |provider_type| send("#{provider_type}_provider_can_#{name}") }
    end
  end

private

  def at_least_one_active_permission_in_pair
    PERMISSIONS.each do |permission|
      if !send("training_provider_can_#{permission}") && !send("ratifying_provider_can_#{permission}")
        errors.add(permission, "Select which organisations can #{permission.to_s.humanize.downcase}")
      end
    end
  end
end
