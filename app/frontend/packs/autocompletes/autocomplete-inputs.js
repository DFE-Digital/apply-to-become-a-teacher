const countryAutocompleteInputs = {
  inputIds: [
    "#candidate-interface-contact-details-form-country-field",
    "#candidate-interface-contact-details-form-country-field-error",
    "#candidate-interface-degree-institution-form-institution-country-field",
    "#candidate-interface-degree-institution-form-institution-country-field-error",
    "#candidate-interface-gcse-institution-country-form-institution-country-field",
    "#candidate-interface-gcse-institution-country-form-institution-country-field-error",
    "#candidate-interface-other-qualification-details-form-institution-country-field",
    "#candidate-interface-other-qualification-form-institution-country-field-error",
    "#support-interface-application-forms-edit-address-details-form-country-field",
    "#support-interface-application-forms-edit-address-details-form-country-field-error",
  ],
  autocompleteId: 'country-autocomplete'
}

const nationalityAutocompleteInputs = {
  inputIds: [
    "candidate-interface-nationalities-form-first-nationality-field",
    "candidate-interface-nationalities-form-first-nationality-field-error",
    "candidate-interface-nationalities-form-second-nationality-field",
    "candidate-interface-nationalities-form-second-nationality-field-error",
    "candidate-interface-nationalities-form-other-nationality1-field",
    "candidate-interface-nationalities-form-other-nationality1-field-error",
    "candidate-interface-nationalities-form-other-nationality2-field",
    "candidate-interface-nationalities-form-other-nationality2-field-error",
    "candidate-interface-nationalities-form-other-nationality3-field",
    "candidate-interface-nationalities-form-other-nationality3-field-error",
  ],
  autocompleteId: 'nationality-autocomplete'
}

const providerAutocompleteInputs = {
  inputIds: [
    "#pick-provider-form .govuk-select"
  ],
  autocompleteId: 'provider-autocomplete'
}

const courseAutocompleteInputs = {
  inputIds: [
    "#pick-course-form .govuk-select"
  ],
  autocompleteId: 'course-autocomplete'
}

const apiTokenAutocomplete = {
  inputIds: [
    "#vendor-api-token-provider-id-field.govuk-select"
  ],
  autocompleteId: 'api-token-autocomplete'
}

export const autocompleteInputs = [
  countryAutocompleteInputs,
  nationalityAutocompleteInputs,
  providerAutocompleteInputs,
  courseAutocompleteInputs,
  apiTokenAutocomplete
]
