Given /^the date time input "([^"]*)"$/ do |raw_str|
  @raw_str = raw_str
end

When /^the data filter is run$/ do
  @output = TEAUTIL.get_date_array(@raw_str)
end

Then /^the date time output should be "([^"]*)"$/ do |result|
  result = result.split(' ')
  expect(@output).to eq(result)
end

When /^the data string filter is run$/ do
  @output = TEAUTIL.get_date_seconds(@raw_str).to_s
  # @output = Time.now.to_s
end

When /^the data string convert is run$/ do
  @output = Time.at(@raw_str.to_i)
end

Then /^the date time string output should be "([^"]*)"$/ do |result|
  expect(@output).to eq(result)
end