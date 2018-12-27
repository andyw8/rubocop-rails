# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop checks for use of the Timecop gem.
      # Rails 4.1 added TimeHelpers to ActiveSupport. This can
      # replace most uses of the Timecop gem, meaning one less
      # external dependency for your project.
      #
      # @example
      #   # bad
      #   Timecop.freeze Time.now.utc
      #
      #   # good
      #   travel_to Time.now.utc
      class Timecop < Cop
        MSG = 'Use the Rails built-in time helpers instead of Timecop.'.freeze
        def on_send(node)
          receiver, _method, _args = *node
          return unless receiver && receiver.source == 'Timecop'

          add_offense(node)
        end
      end
    end
  end
end
