Given /^the input "([^"]*)"$/ do |raw_str|
  @raw_str = raw_str
end

Given /^the key "([^"]*)"$/ do |raw_key|
  @raw_key = raw_key
end

When /^the encrypt is run$/ do
  @output = XXTEA.get_encrypt_string(@raw_str, @raw_key)
end

Then /^the output should be "([^"]*)"$/ do |encrypt_str|
  expect(@output).to eq(encrypt_str)
end


Given /^there is User with email "([^"]*)"$/ do |email|
  @user = FactoryGirl.create(:user, email: email, password: "12345678")
  @user_email = email
end

Given /^there is Device with device id "([^"]*)"$/ do |device_id|
  @dev = FactoryGirl.create(:device, device_id: device_id, user: @user)
end

Given /^there is string ""$/ do
end

When /^visit the path$/ do
end
Then /^the output should be true$/ do
  expect(@user.email).to eq(@user_email)
  expect(@user.devices.count).to eq(1)
end