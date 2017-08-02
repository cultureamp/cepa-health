# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

require 'cepa-health'

describe CepaHealth do

  before(:each) { CepaHealth.clear_probes! }

  it "should register and execute successful probes" do
    standard_setup
    should_be(true, 4)
  end

  it "should register a failure on any unsuccessful probe" do
    standard_setup
    CepaHealth.register { ["Fail", false] }
    CepaHealth.register { ["Four", true] }
    should_be(false, 6)
  end

  it "should allow the registration of probes in levels" do
    CepaHealth.register { ["One", false] }
    CepaHealth.register('error') { ["Two", false] }
    CepaHealth.register('warn') { ["Three", true] }
    CepaHealth.register('warn') { ["Four", true] }
    CepaHealth.register('warn') { ["Five", true] }
    should_be(false, 5)
    should_be(false, 2, "error")
    should_be(true, 3, "warn")
    should_be(false, 5, %w{error warn other})
  end

  protected

  def should_be(ok, record_length, filters = [])
    r = CepaHealth.execute(*filters)
    r.success?.should == ok
    r.records.length.should == record_length
    r.success?
  end

  def standard_setup
    CepaHealth.register { ["One", true] }
    CepaHealth.register { ["Two", true] }
    CepaHealth.register { record("Three-B", true, ""); ["Three", true] }
  end
end
