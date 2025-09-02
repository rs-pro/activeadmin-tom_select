module ActiveAdmin
  module Inputs
    # Searchable select input type for ActiveAdmin filters.
    #
    # @see ActiveAdmin::SearchableSelect::SelectInputExtension
    #   SelectInputExtension for list of available options.
    class SearchableSelectInput < Formtastic::Inputs::SelectInput
      include ActiveAdmin::SearchableSelect::SelectInputExtension
    end
  end
end
