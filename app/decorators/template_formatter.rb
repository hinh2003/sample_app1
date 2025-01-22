# frozen_string_literal: true

# template_formatter.rb
module TemplateFormatter
  TEMPLATE_PATH = Rails.root.join('config/messages')

  def format_template(template_name, values = {})
    template = File.read(TEMPLATE_PATH.join(template_name))
    values.empty? ? template : format(template, values)
  end
end
