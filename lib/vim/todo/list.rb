module Vim
  module Todo
    class List < Array
      EXCLUDE = '*/.git/*'
      PATTERN = 'TODO|FIXME'

      def initialize
        read
      end

      def read
        clear
        `find . -not -path "#{EXCLUDE}" -print | xargs grep -EIn "#{PATTERN}"`.each_line do |line|
          if line =~ /(.*):(\d+):.*(?:TODO|FIXME)\W*(\w+.*)?/
            self << Item.new($1, $2, $3 ? $3.strip : '-')
          end
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
