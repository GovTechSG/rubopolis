# frozen_string_literal: true

require 'rubocop/cop/mixin/active_record_helper'

module Rubopolis
  module Cop
    # This cop is used to identify usages of `find_by` or `where` with string or params inputs.
    # Use either hash or array input to avoid potential SQL injection.
    # Feel free to disable the rule manually if code is assessed to be safe from injection.

    # @example
    #   # bad
    #   User.find_by("name = 'Bruce'")
    #   User.find_by(params[:name_query])
    #
    #   # good
    #   User.find_by('name = ?', 'Bruce')
    #   User.find_by(['name = ?', 'Bruce'])
    #   User.find_by(name: 'Bruce')
    class QueryInjection < RuboCop::Cop::Base
      include RuboCop::Cop::RangeHelp
      include RuboCop::Cop::ActiveRecordHelper

      MSG = '`%s` should be called with hash or array arguments only: see lib/custom_cops/query_injection'

      def on_send(node)
        return if node.receiver.nil? && !inherit_active_record_base?(node)
        return unless method?(node)
        return unless where_or_find_by?(node)
        return if acceptable_arg?(node.arguments[0])

        # when arguments are > 1 strings, it should be templated and are most likely safe.
        return if node.arguments.length > 1

        range = offense_range(node)
        add_offense(range, message: format(MSG, @method))
      end

      private

      def offense_range(node)
        range_between(node.loc.selector.begin_pos, node.arguments[0].loc.expression.end_pos)
      end

      def method?(node)
        node.arguments.any? && node.respond_to?(:method?)
      end

      def where_or_find_by?(node)
        if node.method?(:where)
          @method = 'where'
          return true
        elsif node.method?(:find_by)
          @method = 'find_by'
          return true
        end

        false
      end

      def array?(node)
        node.is_a?(RuboCop::AST::ArrayNode)
      end

      def kwarg?(node)
        node.is_a?(RuboCop::AST::HashNode)
      end

      def acceptable_arg?(node)
        # TODO: current implementation does not allow generated arguments
        # i.e. find_by(function_that_returns_hash)
        #
        # if this is desired:
        # - raise a chore ticket to update this cop
        # - update rubocop_todo.yml to ignore the file in question OR
        # - temporarily disable the rule in the file with an inline comment

        array?(node) || kwarg?(node)
      end
    end
  end
end
