# frozen_string_literal: true

require 'rubocop/cop/rails/concern_misuse'

RSpec.describe RuboCop::Cop::Rails::ConcernMisuse, :config do
  # TODO: Write test code
  #
  # For example
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      included do
        include Foo
        ^^^^^^^^^^^ Avoid using `include` within an `included` block.
      end
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      included do
        something_else
      end
    RUBY
  end
end
