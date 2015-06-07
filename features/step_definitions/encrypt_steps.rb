Given /^the input "([^"]*)"$/ do |raw_str|
  @raw_str = raw_str
end

Given /^the key "([^"]*)"$/ do |raw_key|
  @raw_key = raw_key
end

When /^the encrypt is run$/ do
  @output = XXTEA.get_encrypt_str(@raw_str, @raw_key)
end

When /^the decrypt is run$/ do
  @output = XXTEA.get_decrypt_str(@raw_str, @raw_key)
end

Then /^the output should be "([^"]*)"$/ do |encrypt_str|
  expect(@output).to eq(encrypt_str)
end

Given /^there is User with account email "([^"]*)" and user email "([^"]*)"$/ do |account_email, user_email|
  @user = FactoryGirl.create(:user, email: account_email, password: "12345678")
  @user_email = user_email
end

Given /^there is Device with device id "([^"]*)"$/ do |device_id|
  @dev = FactoryGirl.create(:device, device_id: device_id, user: @user)
  puts @dev.device_id
  puts @dev.user.email
end

Given /^there is string "([^"]*)"$/ do |str|
  raw_str = str
  @raw_key = @user.get_device_key
  @encrypt_str = XXTEA.get_encrypt_str(raw_str, @raw_key)
end

When /^visit the datetime path$/ do
  user_email = @user_email
  query_data = @encrypt_str
  visit apibase_datetime_path(:user => user_email, :data => query_data)
end

When /^visit the cmdquery path$/ do
  user_email = @user_email
  query_data = @encrypt_str
  visit apibase_cmdquery_path(:user => user_email, :data => query_data)
end

Then /^the page output should be "([^"]*)"$/ do |expect_result|
  # expect(@user.email).to eq(@user_email)
  # expect(@user.devices.count).to eq(1)
  # expect(response).to eq("")
  # response.should contain("Home")
  # expect(@encrypt_str).to eq("123")
  # @response.status.should = "200"
  # response.should success?
  # expect(page.status).to eq("200")
  # page.body.should contain("Home")
  # expect(current_path).to eq(root_path)
  # expect(page).to have_content('result')
  # result = page.all('body').map do |body|
  #   body.text
  # end
  # puts result = result.join
  find('body')
  puts result = page.find('body').text
  expect(result).to match(/^result:([a-f0-9]{5,})$/)
  result = result.split(':')[1]
  puts result = XXTEA.get_decrypt_str(result, @raw_key)
  # expect_result = "result"
  # expect(result).to eq("result")
  # expect_result.diff!(result)
  # expect(expect_result).to eq(result)
  expression = /^0,(19|20)\d\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3])([0-5][0-9])([0-5][0-9]),([a-zA-Z0-9]{16})$/
  expect(result).to match(expression)
  # expect(result).to match(/^1234$/)
end

Then /^the page output with wrong dev id should be "result:2,,random"$/ do
  find('body')
  puts result = page.find('body').text
  expect(result).to match(/^result:([a-f0-9]{5,})$/)
  result = result.split(':')[1]
  puts result = XXTEA.get_decrypt_str(result, @raw_key)
  expect(result).to match(/^2,,([a-zA-Z0-9]{16})$/)
end

Then /^the page output with cmdquery should be "result:0,cmdquery,random"$/ do
  find('body')
  puts result = page.find('body').text
  expect(result).to match(/^result:([a-f0-9]{5,})$/)
  result = result.split(':')[1]
  puts result = XXTEA.get_decrypt_str(result, @raw_key)
  expect(result).to match(/^0,,([a-zA-Z0-9]{16}),([a-zA-Z0-9]{4})$/)
end