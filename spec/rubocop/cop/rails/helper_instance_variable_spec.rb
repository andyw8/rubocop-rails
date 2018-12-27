# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::HelperInstanceVariable do
  subject(:cop) { described_class.new }

  it 'registers an offense when using Timecop' do
    expect_offense(<<-RUBY.strip_indent)
      Timecop.foo
      ^^^^^^^^^^^ Use the Rails built-in time helpers instead of Timecop.
    RUBY
  end

  Time.now

  it 'does not register an offense when using the built in time helpers' do
    expect_no_offenses('travel_to(Date.tomorrow)')
  end
end
