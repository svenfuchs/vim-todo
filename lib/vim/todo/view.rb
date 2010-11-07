module Vim
  module Todo
    class View
      attr_reader :list

      def initialize(list)
        @list = list
      end

      def render
        list.map do |item|
          "#{column(item)} #{item.text}"
        end
      end

      def column(item)
        "#{item.filename}:#{item.line}:".ljust(list.max_filename_length + 3)
      end
    end
  end
end

