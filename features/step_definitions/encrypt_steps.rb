Given /^the input "([^"]*)"$/ do |raw_str|
  @raw_str = raw_str
end

Given /^the key "([^"]*)"$/ do |raw_key|
  @raw_key = raw_key
end

When /^the encrypt is run$/ do
  xxtea = XXTEA.new
  @output = xxtea.get_encrypt_string(@raw_str, @raw_key)
end

Then /^the output should be "([^"]*)"$/ do |encrypt_str|
  @output.should == encrypt_str
end