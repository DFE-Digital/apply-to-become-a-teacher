module SupportInterface
  class TransitionDashboard
    END_OF_CYCLE = Date.new(2021, 10, 4).freeze

    def business_days_til_end_of_cycle
      Date.today.business_days_until(END_OF_CYCLE)
    end

    def percent_onboarded
      ((total_onboarded.to_f / total_providers.to_f) * 100).floor
    end

    def left_to_onboard
      total_providers - total_onboarded
    end

    def total_providers
      total.values.inject(:+)
    end

    def total_onboarded
      onboarded.values.inject(:+)
    end

    def scitts
      [onboarded['scitt'], total['scitt']]
    end

    def universities
      [onboarded['university'], total['university']]
    end

    def school_directs
      [onboarded['lead_school'], total['lead_school']]
    end

    def last_5_onboarded
      Provider.joins(:provider_agreements).distinct.order('provider_agreements.accepted_at DESC').select('name', 'provider_agreements.accepted_at as dsa_date').limit(5)
    end

  private

    def onboarded
      @_onboarded = Provider.joins(:provider_agreements).where.not(provider_type: nil).select(:id).group(:provider_type).count
    end

    def total
      @_total = Provider.group(:provider_type).where.not(provider_type: nil).count
    end
  end
end
