# frozen_string_literal: true

require 'rubocop'

module Rubopolis
  module Cop
    # This cop is used to enforce proper migration filename in codebase

    # @example
    #   # bad
    #   Manipulating the filename timestamp to be the future
    #
    #   # good
    #   System generated filename
    class MigrationFilename < RuboCop::Cop::Base
      include RuboCop::Cop::RangeHelp

      MSG_FUTURE_TIMESTAMP = 'The name of this file (`%<basename>s`) should not use future timestamp.'

      def on_new_investigation
        file_path = processed_source.file_path

        return unless file_path.include?('/db/')

        for_bad_filename(file_path) { |range, msg| add_offense(range, message: msg) }
      end

      def for_bad_filename(file_path)
        basename = File.basename(file_path)

        filename_datetime = basename.split('_', 2).first
        current_timestamp = Time.now.strftime('%Y%m%d%H%M%S')

        msg = format(MSG_FUTURE_TIMESTAMP, basename: basename) if filename_datetime > current_timestamp

        yield source_range(processed_source.buffer, 1, 0), msg if msg
      end
    end
  end
end
