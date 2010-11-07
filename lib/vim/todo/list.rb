module Vim
  module Todo
    class List < Array
      def initialize
        read
      end

      def read
        # --exclude --include -A 2 -B 2
        `grep -Hnr TODO .`.each_line do |line|
          self << Item.new(line)
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

      def initialize(line)
        @filename, @line, @text = parse(line)
      end

      def parse(line)
        line =~ /(.*):(\d+):.*(?:TODO|FIXME)\W*(\w+.*)/
        [$1, $2, $3.strip]
      end
    end
  end
end
