module Vim
  module Todo
    class List < Array
      def initialize
        read
      end

      def read
        `find . -not -path "*/.git/*" -print | xargs grep -In TODO`.each_line do |line|
          if line =~ /(.*):(\d+):.*(?:TODO|FIXME)\W*(\w+.*)?/
            self << Item.new($1, $2, $3 ? $3.strip : '-')
          end
        end
      end

      def max_filename_length
        @max_filename_length ||= begin
          item = sort_by_filename_length.last
          "#{item.filename}#{item.line}".length
        end
      end

      def sort_by_filename_length
        sort do |lft, rgt|
          "#{lft.filename}#{lft.line}".length <=> "#{rgt.filename}#{rgt.line}".length
        end
      end
    end

    class Item
      attr_reader :filename, :line, :text

      def initialize(filename, line, text)
        @filename, @line, @text = filename, line, text
      end
    end
  end
end
