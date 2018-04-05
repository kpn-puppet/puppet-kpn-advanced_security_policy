# frozen_string_literal: true

require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure { |c| c.fail_fast = true }

at_exit { print "Resource coverage report is N/A for custom provider type\n\n" }
