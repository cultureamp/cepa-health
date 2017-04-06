# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

if defined?(Mongoid)

  CepaHealth.register do
    value = { 'ok' => nil }
    tries = 3
    begin
      value = Mongoid.default_client.command(ping: 1)
    rescue
      sleep 1
      tries -= 1
      retry unless tries <= 0
    end

    [ "Mongoid", value.ok?, "Ping Database"]
  end

end
