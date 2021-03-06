require 'test_helper'
require 'net/dns/rr'

class RRATest < Test::Unit::TestCase

  def setup
    @rr_name    = "google.com."
    @rr_type    = "A"
    @rr_cls     = "IN"
    @rr_ttl     = 10800
    @rr_address = "64.233.187.99"

    @rr_output  = "google.com.             10800   IN      A       64.233.187.99"
  end


  def test_initialize_from_hash
    @record = Net::DNS::RR::A.new(:name => @rr_name, :address => @rr_address)
    assert_equal @rr_output,  @record.inspect
    assert_equal @rr_name,    @record.name
    assert_equal @rr_type,    @record.type
    assert_equal @rr_cls,     @record.cls
    assert_equal @rr_ttl,     @record.ttl
    assert_equal @rr_address, @record.address.to_s
  end

  def test_initialize_from_string
    @record = Net::DNS::RR::A.new("#{@rr_name} 10800 IN A #{@rr_address}")
    assert_equal @rr_output,  @record.inspect
    assert_equal @rr_name,    @record.name
    assert_equal @rr_type,    @record.type
    assert_equal @rr_cls,     @record.cls
    assert_equal @rr_ttl,     @record.ttl
    assert_equal @rr_address, @record.address.to_s
  end

  def test_parse
    data = "\006google\003com\000\000\001\000\001\000\000*0\000\004@\351\273c"
    @record = Net::DNS::RR.parse(data)
    assert_equal @rr_output,  @record.inspect
    assert_equal @rr_name,    @record.name
    assert_equal @rr_type,    @record.type
    assert_equal @rr_cls,     @record.cls
    assert_equal @rr_ttl,     @record.ttl
    assert_equal @rr_address, @record.address.to_s
  end


  InvalidArguments = [
    { :name => "google.com", :address => "255.256" },
    { :name => "google.com" },
    Object.new,
    Array.new(7),
    "10800 IN A",
    "google.com. 10800 IN B",
    "google.com. 10800 IM A",
  ]

  InvalidArguments.each_with_index do |arguments, index|
    define_method "test_initialize_should_raise_with_invalid_arguments_#{index}" do
      assert_raise(ArgumentError) { Net::DNS::RR::A.new(arguments) }
    end
  end

end

