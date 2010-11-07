module Vim
  module Todo
    module Controller
      attr_reader :list, :view

      def init
        @list = List.new
        @view = View.new(list)
        render
      end

      def action(action)
        send(action)
      end

      def open
        item = current
        cmd "sp #{item.filename}"
        cmd "norm #{item.line}G"
      end

      def refresh
        list.read
        render
      end

      def current
        list[line_number]
      end

      def line_number
        buffer.line_number - 1
      end

      def render
        unlocked do
          buffer.display(view.render)
        end
      end
    end
  end
end

