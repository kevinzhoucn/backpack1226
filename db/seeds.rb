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