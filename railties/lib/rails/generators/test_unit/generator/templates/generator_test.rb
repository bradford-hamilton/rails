# frozen_string_literal: true

require 'test_helper'
require '<%= generator_path %>'

<% module_namespacing do -%>
class <%= class_name %>GeneratorTest < Quails::Generators::TestCase
  tests <%= class_name %>Generator
  destination Quails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
<% end -%>
