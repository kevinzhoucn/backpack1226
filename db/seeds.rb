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

channel = Channel.find("5571a1c15530313648010000")
# channel.update_attribute(:data_points, "100-20150810T120504P112||115-20150810T120508P122||120-20150810T120608P122")
# channel.add_point("125-20150810T120704P112")
# channel.points.delete_all
# channel.add_point("130-20150810T120714P112")
# channel.add_point("135-20150810T120720P112")
# channel.add_point("138-20150810T120725P112")
# channel.add_point("142-20150810T120728P112")
# channel.add_point("155-20150810T120729P112")
# channel.add_point("135-20150810T120750P112")
channel.add_point("115-20150810T120820P112")

# Office Mongodb
# channel = Channel.find("55d69f81553031161c000000")
# channel.update_attribute(:data_points, "100-20150810T100504P112||105-20150810T100508P122||120-20150810T100608P122||105-20150810T100708P122||115-20150811T100808P122||105-20150812T100812P122||115-20150813T100908P122")
# channel.update_attribute(:data_points, "100-20150810T100504P112||105-20150810T100508P122||105-20150810T100518P122||105-20150810T100528P122||105-20150810T100538P122||105-20150810T100608P122")
