# frozen_string_literal: true

module MailerHelper
  def create_table_row(record, attribute, preffered_heading = nil)
    table_cell_styling = 'padding: 5px; border: 1px solid rgb(227, 223, 203); width: 30%'
    content_tag(:tr,
                content_tag(:th, (preffered_heading || attribute), style: table_cell_styling) +
                content_tag(:td, record.send(attribute.split.join('_').downcase.to_s), style: table_cell_styling))
  end

  def row
    raw(
      "<tr>
        <td class='txtsize' valign='top' style='border:0px;'>
          <div class='ukwselement-wrapper text'>
            <table title='' cellspacing='0' cellpadding='0' style='text-rendering: optimizeLegibility;font-size:13px;letter-spacing:normal;font-family:Arial, Helvetica, sans-serif;min-width:100%;max-width:100%;table-layout:fixed;border:0px;border-collapse:collapse;background-color:rgba(0, 0, 0, 0);' width='100%'>
              <tbody>
                <tr>
                  <td style='word-wrap:break-word;word-break:break-word;border:0px;padding:6px 16px;border-top:0px none rgb(17, 17, 17);border-bottom:0px none rgb(17, 17, 17) ;font-family:Arial, Helvetica, sans-serif'>
                    #{yield}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </td>
      </tr>"
    )
  end

  def row_double_column(first_column, second_column)
    row do
      column(first_column) +
        column(second_column)
    end
  end

  def row_single_column(content)
    row do
      column(content, single: true)
    end
  end

  def default_font_family
    'Arial, Helvetica, sans-serif'
  end

  def paragraph(content, opts = {})
    font_size = font_converter(opts[:size])
    rgb_color = font_size == :large ? 'rgb(0, 0, 0)' : 'rgb(17, 17, 17)'
    font_family = opts[:font] || default_font_family

    raw(
      "<p style='padding: 0px; margin: 0px'>
        <font size='#{font_size}' face='#{font_family}' style='padding: 0px; margin: 0px'>
          <span 'style=color: #{rgb_color}; font-family: #{font_family}, sans-serif; padding: 0px; margin: 0px'>
            #{content}
          </span>
        </font>
      </p>"
    )
  end

  def add_spacer(_height = nil)
    raw(
      '<tr>
        <td class="txtsize" valign="top" style="border:0px;">
          <div class="ukwselement-wrapper spacebar">
            <table title="" cellspacing="0" cellpadding="0" style="min-width:100%;max-width:100%;table-layout:fixed;border:0px;border-collapse:collapse;background-color:rgba(0, 0, 0, 0);" width="100%">
              <tbody>
                <tr>
                  <td style="height:15px;border:0px;border-top:0px none rgb(17, 17, 17);border-bottom:0px none rgb(17, 17, 17)">
                    <p style="height:15px;margin:0px;padding:0px;"></p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </td>
      </tr>'
    )
  end

  def li_item(content)
    raw("
      <li>
        <font size='3' style='padding: 0px; margin: 0px'>
          <span style='color: rgb(17, 17, 17); font-family: Arial, Helvetica, sans-serif; font-size: small; font-weight: 400; padding: 0px; margin: 0px'>
              #{content}
            </span>
          </span>
        </font>
      </li>
    ")
  end

  private

  def font_converter(size = nil)
    case size
    when :large then 4
    when :small then 2
    when :tiny then 1
    else
      2
    end
  end

  def column(content, single: false)
    width = single ? '100%' : '48.5%'

    raw(column_wrapper(
          "<div class='ukwselement-wrapper text'>
        <table title='' cellspacing='0' cellpadding='0' style='min-width:100%;max-width:100%;table-layout:fixed;border:0px;border-collapse:collapse;background-color:rgba(0, 0, 0, 0);' width='100%'>
          <tbody>
            <tr>
              <td style='word-wrap:break-word;word-break:break-word;border:0px;padding:6px 8px;border-top:0px none rgb(17, 17, 17);border-bottom:0px none rgb(17, 17, 17) ;font-family:Arial, Helvetica, sans-serif'>
                #{content}
              </td>
            </tr>
          </tbody>
        </table>
      </div>",
          width
        ))
  end

  def column_wrapper(content, width)
    "<table class='cols' align='left' width='#{width}' title='' cellspacing='0' cellpadding='0' style='border:0px;max-width:#{width};border:0px;border-collapse:collapse;background-color:rgba(0, 0, 0, 0);'>
      <tbody>
        <tr>
          <td style='border:0px;border-top:0px none rgb(17, 17, 17);border-bottom:0px none rgb(17, 17, 17)'>
            <div class='ukwswrapper col-space'>
              #{content}
            </div>
          </td>
        </tr>
      </tbody>
    </table>"
  end
end
