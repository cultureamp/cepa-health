# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

if defined?(ActiveRecord) && defined?(SQLite3)

  CepaHealth.register :sqlite do
    begin
      ActiveRecord::Base.connection.exec_query("PRAGMA quick_check")
      [ "SQLite", true, "Quick Check" ]
    rescue Exception => e
      [ "SQLite", false, e.inspect ]
    end
  end

end
