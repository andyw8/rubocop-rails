# frozen_string_literal: true

require "spoom_client"

module RuboCop
  module Cop
    module Rails
      # Checks that ActiveRecord aliases are not used. The direct method names
      # are more clear and easier to read.
      #
      # @safety
      #   This cop is unsafe because custom `update_attributes` method call was changed to
      #   `update` but the method name remained same in the method definition.
      #
      # @example
      #   #bad
      #   book.update_attributes!(author: 'Alice')
      #
      #   #good
      #   book.update!(author: 'Alice')
      class ActiveRecordAliasesTyped < Base
        extend AutoCorrector

        MSG = 'Use `%<prefer>s` instead of `%<current>s`.'

        ALIASES = { update_attributes: :update, update_attributes!: :update! }.freeze

        RESTRICT_ON_SEND = ALIASES.keys.freeze

        def on_send(node)
          return if node.arguments.empty?

          return unless receiver_is_an_application_record?(node)

          method_name = node.method_name
          alias_method = ALIASES[method_name]

          add_offense(
            node.loc.selector,
            message: format(MSG, prefer: alias_method, current: method_name),
            severity: :warning
          ) do |corrector|
            corrector.replace(node.loc.selector, alias_method)
          end
        end

        alias on_csend on_send

        def receiver_is_an_application_record?(node)
          spoom_client = SpoomClient.new(node, processed_source)
          spoom_client.contents.match?(/class .* < ApplicationRecord$/)
        end
      end
    end
  end
end
