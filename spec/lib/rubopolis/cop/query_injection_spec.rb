# frozen_string_literal: true

require './spec/cop_helper'
require './lib/rubopolis/cop/query_injection'

RSpec.describe Rubopolis::Cop::QueryInjection, :config do
  describe '#find_by' do
    it 'registers an offense when using `#find_by` with string' do
      expect_offense(<<~RUBY)
        Grant.find_by("asdf")
              ^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when using `#find_by` with params' do
      expect_offense(<<~RUBY)
        Grant.find_by(params[:some_params])
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when chained' do
      expect_offense(<<~RUBY)
        Grant.select("some search criteria").find_by("asdf")
                                             ^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when dynamically generating the arguments' do
      expect_offense(<<~RUBY)
        Grant.select("some search criteria").find_by(fn_name)
                                             ^^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'does not register an offense when using `#find_by` with hash' do
      expect_no_offenses(<<~RUBY)
        Grant.find_by(ref_id: params[:some_params])
      RUBY
    end

    it 'does not register an offense when using `#find_by` with array' do
      expect_no_offenses(<<~RUBY)
        Grant.find_by(['ref_id = ?', params[:id]])
      RUBY
    end

    it 'does not register an offense when using `#find_by` with more than one argument' do
      expect_no_offenses(<<~RUBY)
        Grant.find_by('ref_id = ?', params[:id])
      RUBY
    end

    it 'does not register an offense when not inheriting `ApplicationRecord`' do
      expect_no_offenses(<<~RUBY)
        class Test < Foo
          find_by("asdf")
        end
      RUBY
    end

    it 'registers an offense when inheriting `ApplicationRecord`' do
      expect_offense(<<~RUBY)
        class Test < ApplicationRecord
          find_by("asdf")
          ^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
        end
      RUBY
    end

    it 'does not register an offense when inheriting `ApplicationRecord` but with correct synax' do
      expect_no_offenses(<<~RUBY)
        class Test < ApplicationRecord
          find_by(ref_id: 'test')
        end
      RUBY
    end

    it 'registers an offense when inheriting `ActiveRecord::Base`' do
      expect_offense(<<~RUBY)
        class Test < ActiveRecord::Base
          find_by("asdf")
          ^^^^^^^^^^^^^^ `find_by` should be called with hash or array arguments only: see lib/custom_cops/query_injection
        end
      RUBY
    end

    it 'does not register an offense when inheriting `ActiveRecord::Base` but with correct synax' do
      expect_no_offenses(<<~RUBY)
        class Test < ActiveRecord::Base
          find_by(ref_id: 'test')
        end
      RUBY
    end
  end

  describe '#where' do
    it 'registers an offense when using `#where` with string' do
      expect_offense(<<~RUBY)
        Grant.where("asdf")
              ^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when using `#where` with params' do
      expect_offense(<<~RUBY)
        Grant.where(params[:some_params])
              ^^^^^^^^^^^^^^^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when chained' do
      expect_offense(<<~RUBY)
        Grant.select("some search criteria").where("asdf")
                                             ^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'registers an offense when dynamically generating the arguments' do
      expect_offense(<<~RUBY)
        Grant.select("some search criteria").where(fn_name)
                                             ^^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
      RUBY
    end

    it 'does not register an offense when using `#where` with hash' do
      expect_no_offenses(<<~RUBY)
        Grant.where(ref_id: params[:some_params])
      RUBY
    end

    it 'does not register an offense when using `#where` with array' do
      expect_no_offenses(<<~RUBY)
        Grant.where(['ref_id = ?', params[:id]])
      RUBY
    end

    it 'does not register an offense when using `#where` with more than one argument' do
      expect_no_offenses(<<~RUBY)
        Grant.where('ref_id = ?', params[:id])
      RUBY
    end

    it 'does not register an offense when not inheriting `ApplicationRecord`' do
      expect_no_offenses(<<~RUBY)
        class Test < Foo
          where("asdf")
        end
      RUBY
    end

    it 'registers an offense when inheriting `ApplicationRecord`' do
      expect_offense(<<~RUBY)
        class Test < ApplicationRecord
          where("asdf")
          ^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
        end
      RUBY
    end

    it 'does not register an offense when inheriting `ApplicationRecord` but with correct synax' do
      expect_no_offenses(<<~RUBY)
        class Test < ApplicationRecord
          where(ref_id: 'test')
        end
      RUBY
    end

    it 'registers an offense when inheriting `ActiveRecord::Base`' do
      expect_offense(<<~RUBY)
        class Test < ActiveRecord::Base
          where("asdf")
          ^^^^^^^^^^^^ `where` should be called with hash or array arguments only: see lib/custom_cops/query_injection
        end
      RUBY
    end

    it 'does not register an offense when inheriting `ActiveRecord::Base` but with correct synax' do
      expect_no_offenses(<<~RUBY)
        class Test < ActiveRecord::Base
          where(ref_id: 'test')
        end
      RUBY
    end
  end
end
