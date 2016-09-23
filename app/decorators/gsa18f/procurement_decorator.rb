module Gsa18f
  class ProcurementDecorator < Draper::Decorator
    delegate_all

    def client_code
      "gsa18f"
    end

    def email_display
      translate_strings(email_display_fields)
    end

    def email_display_fields
      %w(purchase_type date_requested quantity urgency cost_per_unit office total_price justification link_to_product additional_info)
    end

    def display
      translate_strings(new_display)
    end

    def translate_strings(element_array)
      stored_displays = []
      element_array.each do |display_el|
        display_string = obj.public_send(display_el) if obj.respond_to? display_el
        translated_el = [translated_key(display_el), display_string]
        stored_displays << translated_el
      end
      stored_displays
    end

    def new_display
      %w(purchase_type office date_requested urgency quantity cost_per_unit link_to_product justification additional_info is_tock_billable tock_project recurring recurring_interval recurring_length total_price)
    end

    def translated_key(key)
      I18n.t("decorators.gsa18f/procurement.#{key}")
    end
  end
end
