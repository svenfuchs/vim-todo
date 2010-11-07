require 'core_ext/ruby/kernel/singleton_class'

require 'vim/layout'
require 'vim/todo/window'

module Vim
  module Todo
    autoload :Controller, 'vim/todo/controller'
    autoload :List, 'vim/todo/list'
    autoload :View, 'vim/todo/view'

    extend Vim

    class << self
      def run
        if window && window.valid?
          window.focus
        else
          path = [path, $curwin.buffer.name, Dir.pwd].compact.detect { |path| !path.empty? }
          path = File.expand_path(path)
          create(path) if File.directory?(path)
        end
      end

      def create(path)
        cmd "silent! bottomright vnew #{@title}"
        window = Vim::Window.last
        window.singleton_class.send(:include, Vim::Todo, Vim::Todo::Controller) # Vim::Layout::Sticky
        window.init
      end

      def action(*args)
        window.action(*args) if window
      end

      def window
        Window.detect(&:todo?)
      end

      def reload
        Dir["#{::Vim.runtime_path('vim-tree')}/lib/**/*.rb"].each { |path| load(path) }
      end
    end

    attr_reader :view

    def init
      super
      init_window
      init_buffer
      init_keys
      init_highlighting
      render
    end

    def init_window
      set_status('TODO')
      # set_buffer_name('TODO')
    end

    def init_buffer
      cmd "setlocal bufhidden=delete"
      cmd "setlocal buftype=nofile"
      cmd "setlocal nomodifiable"
      cmd "setlocal nomodified"
      cmd "setlocal noswapfile"
      cmd "setlocal nowrap"
      cmd "setlocal nonumber"
      cmd "setlocal foldcolumn=0"
      cmd "setlocal cursorline"
      cmd "setlocal nospell"
      cmd "setlocal nobuflisted"
      cmd "setlocal textwidth=0"
      cmd "setlocal winfixwidth"
    end

    def init_keys
      map_key :CR, :open
      map_char :R, :refresh
    end

    def init_highlighting
      cmd 'hi link vimTodoFile Comment'
      cmd 'syn match vimTodoFile "^\S*"'
    end

    def set_status(status)
      cmd "setlocal statusline=#{status}"
    end

    def set_buffer_name(name)
      cmd "silent! file [#{name}]"
    end

    def map_char(char, target = char, options = {})
      map_key :"Char-#{char.to_s.ord}", target, options
    end

    def map_key(key, target = key, options = {})
      map "<#{key}> :ruby Vim::Todo.action('#{target.to_s.downcase}')", options
    end

    def map(command, options = {})
      options[:mode] ||= :nnore
      options[:buffer] = true unless options.key?(:buffer)
      cmd "#{options[:mode]}map #{'<buffer>' if options[:buffer]} #{'<esc>' if options[:mode] == 'i'}#{command}<CR>"
    end
  end
end
