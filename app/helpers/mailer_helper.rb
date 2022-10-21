# frozen_string_literal: true

module MailerHelper
  def create_table_row(record, attribute, preffered_heading = nil)
    table_cell_styling = 'padding: 5px; border: 1px solid rgb(227, 223, 203); width: 30%'
    content_tag(:tr,
                content_tag(:th, (preffered_heading || attribute), style: table_cell_styling) +
                content_tag(:td, record.send(attribute.split(' ').join('_').downcase.to_s), style: table_cell_styling))
  end
end
