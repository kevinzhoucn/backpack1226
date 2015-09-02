module ApplicationHelper
  def render_stylesheets
    style_url = ''
    if SiteConfig.style_url
      style_url = SiteConfig.style_url
    end

    content_tag('link', nil, { data: {turbolinks_track: true }, href: style_url, rel: 'stylesheet' }, false)
  end

  def render_javascripts    
    if controller_name == "front" and action_name == "show_channel_chart"

      @content = content_tag('script', nil, { src: '/js/libs/charts/highstock.js'}, false)
      @content << content_tag('script', nil, { src: '/js/chart/drawChart.js'}, false)
    end

    if controller_name == "apibase" and action_name == "xxtea"
      @content = content_tag('script', nil, { src: '/js/sdk/xxtea.js'}, false)
    end
  end
end
