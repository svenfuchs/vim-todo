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
        compact("#{item.filename}:#{item.line}", 50).ljust(52)
      end

      def compact(path, width)
        PathCompactor.new(path, :sticky => 2).compact(width)
      end

      class PathCompactor < Array
        attr_reader :basename, :liquid, :sticky, :compacted

        def initialize(path, options = {})
          @basename = File.basename(path)
          @liquid = File.dirname(path).split('/')
          @sticky = liquid.slice!(0, options[:sticky] || 1)
          @compacted = []
        end

        def compact(width)
          compacted << liquid.shift until self.width <= width || liquid.empty?
          to_s
        end

        def width
          to_s.length
        end

        def to_s
          dots = '..' unless compacted.empty?
          [sticky, dots, liquid, basename].compact.flatten.join('/')
        end
      end
    end
  end
end

