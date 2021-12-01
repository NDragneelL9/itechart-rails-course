# frozen_string_literal: true

# Module contains helper methods to views/devise
module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    err = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <ul>#{err}</ul>
    HTML
    # rubocop:disable Rails/OutputSafety
    html.html_safe # outputs error_messages
    # rubocop:enable Rails/OutputSafety
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
