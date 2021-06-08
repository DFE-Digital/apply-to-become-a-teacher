class SummaryListComponent < ViewComponent::Base
  include ViewHelper

  def initialize(rows:)
    rows = transform_hash(rows) if rows.is_a?(Hash)
    @rows = rows
  end

  def value(row)
    if row[:value].is_a?(Array)
      row[:value].map { |s| ERB::Util.html_escape(s) }.join('<br>').html_safe
    elsif row[:value].html_safe?
      row[:value]
    else
      simple_format(row[:value], class: 'govuk-body')
    end
  end

  def action(row)
    if row[:change_path]
      {
        href: row[:change_path],
        visually_hidden_text: row[:action],
        classes: 'govuk-!-display-none-print',
      }
    elsif row[:action_path]
      {
        href: row[:action_path],
        text: row[:action],
        classes: 'govuk-!-display-none-print',
      }
    end
  end

private

  attr_reader :rows

  def transform_hash(row_hash)
    row_hash.map do |key, value|
      {
        key: key,
        value: value,
      }
    end
  end
end
