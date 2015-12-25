# coding: utf-8

# 默认配置项
# 如需新增设置项，请在这里初始化默认值，然后到后台修改
# 首页
# SiteConfig.index_html
# SiteConfig.save_default("index_html",<<-eos
# <div class="box" style="text-align:center;">
#   <p><img alt="Big_logo" src="/assets/big_logo.png"></p>
# </div>
# eos
# )

# # Wiki 首页 HTML
# SiteConfig.save_default("wiki_index_html",<<-eos
# <div class="box">
#   Wiki Home page.
# </div>
# eos
# )

# # Footer HTML
# SiteConfig.save_default("footer_html",<<-eos
# <p class="copyright">
#  &copy; China Group.
# </p>
# eos
# )

# SiteConfig.save_default("style_url", "/css/style_white.css")

# channel = Channel.find("5571a1c15530313648010000")
# channel.update_attribute(:data_points, "100-20150810T120504P112||115-20150810T120508P122||120-20150810T120608P122")
# channel.add_point("125-20150810T120704P112")
# channel.points.delete_all
# channel.add_point("130-20150810T120714P112")
# channel.add_point("135-20150810T120720P112")
# channel.add_point("138-20150810T120725P112")
# channel.add_point("142-20150810T120728P112")
# channel.add_point("155-20150810T120729P112")
# channel.add_point("135-20150810T120750P112")
# channel.add_point("115-20150810T120820P112")

# Office Mongodb
# channel = Channel.find("55d69f81553031161c000000")
# channel.update_attribute(:data_points, "100-20150810T100504P112||105-20150810T100508P122||120-20150810T100608P122||105-20150810T100708P122||115-20150811T100808P122||105-20150812T100812P122||115-20150813T100908P122")
# channel.update_attribute(:data_points, "100-20150810T100504P112||105-20150810T100508P122||105-20150810T100518P122||105-20150810T100528P122||105-20150810T100538P122||105-20150810T100608P122")

# channel = Channel.find("561c74785530311364010000")
# channel.points.delete_all

# date_int = 1440457472000
# 3500.times do |x|

# channel = Channel.find("55fe233455303125c8040000")
# channel.points.delete_all

# channel = Channel.find("5666718655303132c0020000")
# channel.points.delete_all

# # date_int = 1440457472000
# date_int = Time.now.to_i * 1000 
# # 3500.times do |x|
# # # 100.times do |x|
# # # 1500.times do |x|
# 100.times do |x|
#   puts x
#   value = x + 1
#   date_int02 = date_int + ( value * 500 )
#   puts date_int02
#   channel.points.create(:value => x, :date_int => date_int02, :seq_num => value)
#   sleep 1
# end

# User.all.each do |user|
#   user.update_attribute(:encrypted_password, '22843f1858e944297e28692d005a1e39')
# end


# channel = Channel.find("55fe233455303125c8040000")
# point = channel.points.last
# date_int = point.date_int
# seq_num = point.seq_num

# 100.times do |x|
#   puts x
#   value = x + 1
#   date_int = date_int.to_i + ( value * 3000 )
#   puts date_int
#   channel.points.create(:value => x, :date_int => date_int, :seq_num => seq_num + value)
#   sleep 1
# end
# channel = Channel.find("561c74785530311364010000")
# # channel.points.delete_all

# point = channel.points.last
# data_value = point.value.to_i
# date_int = point.date_int.to_i
# seq_num = point.seq_num.to_i

# x = 0

# while true do
#   puts x
#   x = value = x + 1
#   date_int = date_int + ( value * 3000 )
#   puts date_int
#   channel.points.create(:value => data_value + value, :date_int => date_int, :seq_num => seq_num + value)
#   sleep 1
# end
# Dmodel.delete_all
# dmode = Dmodel.create(:name => 'JM100-C', :description => 'JM100-C')

# Dchannel.delete_all
# 16.times do |i|  
#   offset = 0;
#   cid = i + offset;
#   description = name = 'Input' + i.to_s;
#   dmodel_id = dmode.id
#   dgroup = '数字输入'
#   dunit = 'unit'
#   Dchannel.create(:cid => cid, :offset => offset, :name => name, :description => description, :dmodel_id => dmodel_id, :dgroup => dgroup)
# end

# 16.times do |i|
#   offset = 32;
#   cid = i + offset;
#   description = name = 'Output' + i.to_s;
#   dmodel_id = dmode.id
#   dgroup = '数字输出'
#   dunit = 'unit'
#   Dchannel.create(:cid => cid, :offset => offset, :name => name, :description => description, :dmodel_id => dmodel_id, :dgroup => dgroup)
# end

# 16.times do |i|
#   offset = 64;
#   cid = i + offset;
#   description = name = 'A Input' + i.to_s;
#   dmodel_id = dmode.id
#   dgroup = '模拟输入'
#   dunit = 'unit'
#   Dchannel.create(:cid => cid, :offset => offset, :name => name, :description => description, :dmodel_id => dmodel_id, :dgroup => dgroup)
# end

# 16.times do |i|
#   offset = 96;
#   cid = i + offset;
#   description = name = 'A Onput' + i.to_s;
#   dmodel_id = dmode.id
#   dgroup = '模拟输出'
#   dunit = 'unit'
#   Dchannel.create(:cid => cid, :offset => offset, :name => name, :description => description, :dmodel_id => dmodel_id, :dgroup => dgroup)
# end

# Devicechannel.create(:device_id => '5652cb09553031656c010000', :dchannel_id => '5656b8d75530315c08010000', :name => 'input0', :enable => true)

# Cmdquery.delete_all


dmode = Dmodel.first
dmode.update_attributes(:name => 'JM100-W', :description => 'JM100-W')
