# frozen_string_literal: true

require 'timecop'
require './spec/cop_helper'
require './lib/rubopolis/cop/migration_filename'

RSpec.describe Rubopolis::Cop::MigrationFilename, :config do
  before do
    Timecop.travel(Time.local(2022, 2, 22, 8, 0, 2))
  end

  after do
    Timecop.return
  end

  it 'does not registers an offense when file is not a migration file' do
    expect_no_offenses(<<~RUBY, '20220222000002_create_some_table.rb')
      print 1
    RUBY
  end

  it 'registers an offense when filename date is later than current date' do
    expect_offense(<<~RUBY, '/db/20220301000000_create_some_table.rb')
      print 1
      ^ The name of this file (`20220301000000_create_some_table.rb`) should not use future timestamp.
    RUBY
  end

  it 'does not registers an offense when filename date is earlier than current date' do
    expect_no_offenses(<<~RUBY, '/db/20220221000000_create_some_table.rb')
      print 1
    RUBY
  end

  it 'does not registers an offense when filename datetime the same as current datetime seconds' do
    expect_no_offenses(<<~RUBY, '/db/20220222080002_create_some_table.rb')
      print 1
    RUBY
  end
end
