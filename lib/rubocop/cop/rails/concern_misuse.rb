# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @safety
      #   Delete this section if the cop is not unsafe (`Safe: false` or
      #   `SafeAutoCorrect: false`), or use it to explain how the cop is
      #   unsafe.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class ConcernMisuse < Base
        MSG = 'Avoid using `include` within an `included` block.'

        def_node_matcher :included_block?, <<~PATTERN
          (block (send nil? :included) _ _)
        PATTERN

        def_node_search :include_call?, <<~PATTERN
          (send nil? :include _)
        PATTERN

        def on_block(node)
          return unless node && included_block?(node)

          # require 'debug'
          # binding.break

          body = node.body
          return unless body

          return unless include_call?(body)

          add_offense(body)
        end
        alias on_numblock on_block
        # # TODO: Implement the cop in here.
        # #
        # # In many cases, you can use a node matcher for matching node pattern.
        # # See https://github.com/rubocop/rubocop-ast/blob/master/lib/rubocop/ast/node_pattern.rb
        # #
        # # For example
        # MSG = 'Use `#good_method` instead of `#bad_method`.'

        # # TODO: Don't call `on_send` unless the method name is in this list
        # # If you don't need `on_send` in the cop you created, remove it.
        # RESTRICT_ON_SEND = %i[bad_method].freeze

        # # @!method bad_method?(node)
        # def_node_matcher :bad_method?, <<~PATTERN
        #   (send nil? :bad_method ...)
        # PATTERN

        # def on_send(node)
        #   return unless bad_method?(node)

        #   add_offense(node)
        # end
      end
    end
  end
end
