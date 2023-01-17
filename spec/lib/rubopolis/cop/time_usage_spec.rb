# frozen_string_literal: true

require './spec/cop_helper'
require './lib/rubopolis/cop/time_usage'

RSpec.describe Rubopolis::Cop::TimeUsage, :config do
  describe 'Time class usage' do
    it 'registers an offense when using `#Time.zone.now` to get current date time' do
      expect_offense(<<~RUBY)
        Time.zone.now
        ^^^^^^^^^^^^^ `Time.zone.now` or `Time.zone.today` should not be used, to consider Time.current or Date.current instead: see lib/custom_cops/time_usage
      RUBY
    end

    it 'registers an offense when using `#Time.zone.today` to get current date' do
      expect_offense(<<~RUBY)
        Time.zone.today
        ^^^^^^^^^^^^^^^ `Time.zone.now` or `Time.zone.today` should not be used, to consider Time.current or Date.current instead: see lib/custom_cops/time_usage
      RUBY
    end

    it 'registers an offense when using subtraction `#Time.current - 3.days` to get past date time' do
      expect_offense(<<~RUBY)
        Time.current - 3.days
        ^^^^^^^^^^^^^^^^^^^^^ Avoid subtracting or adding for Time, to use methods like `ago` and `since/from_now` e.g. `2.weeks.ago`, `5.minutes.since`. Refer to https://api.rubyonrails.org/classes/Time.html for more info
      RUBY
    end

    it 'registers an offense when using addition `#Time.current + 3.days` to get future date time' do
      expect_offense(<<~RUBY)
        Time.current + 3.days
        ^^^^^^^^^^^^^^^^^^^^^ Avoid subtracting or adding for Time, to use methods like `ago` and `since/from_now` e.g. `2.weeks.ago`, `5.minutes.since`. Refer to https://api.rubyonrails.org/classes/Time.html for more info
      RUBY
    end
  end
end
