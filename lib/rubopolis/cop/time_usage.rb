# frozen_string_literal: true

module Rubopolis
  module Cop
    # This cop is used to identify usages of `Time.zone.now` or `Time.zone.today` and any Time class related arithmetic.
    # Use `Time.current` or `Date.current` instead for standardisation.
    # Feel free to disable the rule manually if necessary.

    # @example
    #   # bad
    #   Time.zone.today
    #   Time.zone.now
    #   Time.current + 2.weeks
    #   Time.current - 2.weeks
    #
    #   # good
    #   Date.current
    #   Time.current
    #   2.weeks.ago
    #   2.weeks.since or 2.weeks.from_now
    class TimeUsage < RuboCop::Cop::Base
      USAGE_MSG = '`Time.zone.now` or `Time.zone.today` should not be used, to consider Time.current or ' \
                  'Date.current instead: see lib/custom_cops/time_usage'

      ARITHMETIC_MSG = 'Avoid subtracting or adding for Time, to use methods like `ago` and `since/from_now` e.g. ' \
                       '`2.weeks.ago`, `5.minutes.since`. Refer to https://api.rubyonrails.org/classes/Time.html ' \
                       'for more info'

      def_node_matcher :time_now?, <<~PATTERN
        (send (send (const nil? :Time) :zone) :now)
      PATTERN

      def_node_matcher :time_today?, <<~PATTERN
        (send (send (const nil? :Time) :zone) :today)
      PATTERN

      def_node_matcher :time_addition?, <<~PATTERN
        (send (send (const nil? :Time) :current) :+ $(...))
      PATTERN

      def_node_matcher :time_subtract?, <<~PATTERN
        (send (send (const nil? :Time) :current) :- $(...))
      PATTERN

      def on_send(node)
        if time_now?(node) || time_today?(node)
          message = USAGE_MSG
        elsif time_addition?(node) || time_subtract?(node)
          message = ARITHMETIC_MSG
        else
          return
        end

        add_offense(node, message: message)
      end
    end
  end
end
