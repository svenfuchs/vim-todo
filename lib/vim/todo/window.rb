module Vim
  class Window
    def todo?
      singleton_class.included_modules.include?(Vim::Todo)
    end
  end
end

