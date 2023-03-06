# frozen_string_literal: true

module ApplicationHelper
  def decorate(model, decorate_class = nil)
    (decorate_class || "#{model.class}Decorator".constantize).new(model)
   end
   
  def flash_style(type)
    case type
    when 'notice' then 'primary'
    when 'alert' then 'danger'
    when 'warning' then 'warning'
    when 'info' then 'info'
    when 'success' then 'success'
    end
  end
end
