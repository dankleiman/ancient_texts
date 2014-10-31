module WillPaginate
  module ViewHelpers
    class LinkRenderer < LinkRendererBase

      protected

      def html_container(html)
        tag(:ul, html, { class: 'pagination' })
      end

      def page_number(page)
        tag :li, link(page, page, rel: rel_value(page)), class: ('current' if page == current_page)
      end

      def gap
        tag :li, link('&hellip;', ''), class: 'unavailable'
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), class: ['arrow', ('unavailable' unless page)].join(' ')
      end
    end
  end
end
