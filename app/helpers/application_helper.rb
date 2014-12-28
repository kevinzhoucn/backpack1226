module ApplicationHelper
  def render_stylesheets
    style_url = ''
    if SiteConfig.style_url
      style_url = SiteConfig.style_url
    end

    content_tag('link', nil, { data: {turbolinks_track: true }, href: style_url, rel: 'stylesheet' }, false)
  end
end
