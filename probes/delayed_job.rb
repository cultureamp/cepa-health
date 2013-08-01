# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

if defined?(Delayed)

  CepaHealth.register "Delayed Job" do
    record "Rails Major Version", true, Rails.version.split('.').first
    true
  end

end
