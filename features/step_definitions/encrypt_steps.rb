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
  # puts @dev.device_id
  # puts @dev.user.email
end

Given /^there is string "([^"]*)"$/ do |str|
  raw_str = str
  @raw_key = @user.get_device_key
  @encrypt_str = XXTEA.get_encrypt_str(raw_str, @raw_key)
end

When /^visit the "([^"]*)" path$/ do |path_name|
  user_email = @user_email
  query_data = @encrypt_str

  case path_name
  when "datetime"
    visit apibase_datetime_path(:user => user_email, :data => query_data)
  when "cmdquery"
    visit apibase_cmdquery_path(:user => user_email, :data => query_data)
  end  
end

Then /^the page expect result should be "([^"]*)"$/ do |expect_result|
  find('body')
  puts result = page.find('body').text
  expect(result).to match(/^result:([a-f0-9]{5,})$/)

  if expect_result != "fail"
    str_array = expect_result.split(',')

    express_str = "^"
    express_str << str_array[0]

    case str_array[1]
    when ''
      express_str << ","
    when 'datetime'
      express_str << "," + "(19|20)\\d\\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3])([0-5][0-9])([0-5][0-9])"
    when 'cmdquery'
      express_str << "," + "([0-255]-[[\\d+]|[0-9a-fA-F]]+_?)*"
    end

    case str_array[2]
    when 'random'
      express_str << "," + "([a-zA-Z0-9]{16})"
    end

    if str_array[1] == "cmdquery"
      express_str << "," + "([a-zA-Z0-9]{4})"
    end

    express_str << "$"


    result = result.split(':')[1]
    puts result = XXTEA.get_decrypt_str(result, @raw_key)
    expect(result).to match(/#{express_str}/i)
  end
end