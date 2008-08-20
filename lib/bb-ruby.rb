module BBRuby
  @@imageformats = 'png|bmp|jpg|gif|jpeg'
  @@tags = {
    # tag name => [regex, replace, description, example, enable/disable symbol]
    'Bold' => [
      /\[b(:.+)?\](.*?)\[\/b\1?\]/,
      '<strong>\2</strong>',
      'Embolden text',
      'Look [b]here[/b]',
      :bold],
    'Italics' => [
      /\[i(:.+)?\](.*?)\[\/i\1?\]/,
      '<em>\2</em>',
      'Italicize or emphasize text',
      'Even my [i]cat[/i] was chasing the mailman!',
      :italics],
    'Underline' => [
      /\[u(:.+)?\](.*?)\[\/u\1?\]/,
      '<u>\2</u>',
      'Underline',
      'Use it for [u]important[/u] things or something',
      :underline],
    'Strikeout' => [
      /\[s(:.+)?\](.*?)\[\/s\1?\]/,
      '<del>\2</del>',
      'Strikeout',
      '[s]nevermind[/s]',
      :strikeout],
    'Delete' => [
      /\[del(:.+)?\](.*?)\[\/del\1?\]/,
      '<del>\2</del>',
      'Deleted text',
      '[del]deleted text[/del]',
      :delete],
    'Insert' => [
      /\[ins(:.+)?\](.*?)\[\/ins\1?\]/,
      '<ins>\2</ins>',
      'Inserted Text',
      '[ins]inserted text[/del]',
      :insert],
    'Code' => [
      /\[code(:.+)?\](.*?)\[\/code\1?\]/,
      '<code>\2</code>',
      'Code Text',
      '[code]some code[/code]',
      :code],
    'Size' => [
      /\[size=['"]?(.*?)['"]?\](.*?)\[\/size\]/im,
      '<span style="font-size: \1px;">\2</span>',
      'Change text size',
      '[size=20]Here is some larger text[/size]',
      :size],
    'Color' => [
      /\[color=['"]?(.*?)['"]?\](.*?)\[\/color\]/im,
      '<span style="color: \1;">\2</span>',
      'Change text color',
      '[color=red]This is red text[/color]',
      :color],
  
    'Ordered List' => [
      /\[ol\](.*?)\[\/ol\]/m,
      '<ol>\1</ol>',
      'Ordered list',
      'My favorite people (alphabetical order): [ol][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ol]',
      :orderedlist],
    'Unordered List' => [
      /\[ul\](.*?)\[\/ul\]/m,
      '<ul>\1</ul>',
      'Unordered list',
      'My favorite people (order of importance): [ul][li]Jenny[/li][li]Alex[/li][li]Beth[/li][/ul]',
      :unorderedlist],
    'List Item' => [
      /\[li\](.*?)\[\/li\]/,
      '<li>\1</li>',
      'List item',
      'See ol or ul',
      :listitem],
    # FIXME
    'List Item (alternative)' => [
      /\[\*\]([^\]].*?)$/,
      '<li>\1</li>',
      'List item (alternative)',
      nil, nil,
      :listitem],
  
    'Definition List' => [
      /\[dl\](.*?)\[\/dl\]/m,
      '<dl>\1</dl>',
      'List of terms/items and their definitions',
      '[dl][dt]Fusion Reactor[/dt][dd]Chamber that provides power to your... nerd stuff[/dd][dt]Mass Cannon[/dt][dd]A gun of some sort[/dd][/dl]',
      :definelist],
    'Definition Term' => [
      /\[dt\](.*?)\[\/dt\]/,
      '<dt>\1</dt>',
      'List of definition terms',
      nil, nil,
      :defineterm],
    'Definition Definition' => [
      /\[dd\](.*?)\[\/dd\]/,
      '<dd>\1</dd>',
      'Definition definitions',
      nil, nil,
      :definition],
  
    'Quote' => [
      /\[quote(:.*)?=(.*?)\](.*?)\[\/quote\1?\]/m,
      '<fieldset><legend>\2</legend><blockquote>\3</blockquote></fieldset>',
      'Quote with citation',
      nil, nil,
      :quote],
    'Quote (Sourceless)' => [
      /\[quote(:.*)?\](.*?)\[\/quote\1?\]/m,
      '<fieldset><blockquote>\2</blockquote></fieldset>',
      'Quote (sourceclass)',
      nil, nil,
      :quote],
  
    'Link' => [
      /\[url=(.*?)\](.*?)\[\/url\]/,
      '<a href="\1">\2</a>',
      'Hyperlink to somewhere else',
      'Maybe try looking on [url=http://google.com]Google[/url]?',
      nil, nil,
      :link],
    'Link (Implied)' => [
      /\[url\](.*?)\[\/url\]/,
      '<a href="\1">\1</a>',
      'Hyperlink (implied)',
      nil, nil,
      :link],
    # 
    # TODO: fix automatic links
    #
    # 'Link (Automatic)' => [
    #   /http:\/\/(.*?)[^<\/a>]/,
    #   '<a href="\1">\1</a>',
    #   'Hyperlink (automatic)',
    #   nil, nil,
    #   :link],  
    'Image (Alternative)' => [
      /\[img=([^\[\]].*?)\.(#{@@imageformats})\]/i,
      '<img src="\1.\2" alt="" />',
      'Display an image (alternative format)', 
      '[img=http://myimage.com/logo.gif]',
      :image],
    'Image (Resized)' => [
      /\[img(.+)? size=(['"]?)(\d+)x(\d+)\2\](.*?)\[\/img\1?\]/i,
      '<img src="\5" style="width: \3px; height: \4px;" />',
      'Display an image with a set width and height', 
      '[img size=96x96]http://www.google.com/intl/en_ALL/images/logo.gif[/img]',
      :image],
    'Image' => [
      /\[img(.+)?\]([^\[\]].*?)\.(#{@@imageformats})\[\/img\1?\]/i,
      '<img src="\2.\3" alt="" />',
      'Display an image',
      'Check out this crazy cat: [img]http://catsweekly.com/crazycat.jpg[/img]',
      :image],    
    'YouTube' => [
      /\[youtube\](.*?)\?v=([\w\d\-]+).*\[\/youtube\]/i,
      '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      'Display a video from YouTube.com', 
      '[youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]',
      :video],
    'YouTube (Alternative)' => [
      /\[youtube\](.*?)\/v\/([\w\d\-]+)\[\/youtube\]/i,
      '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
      'Display a video from YouTube.com (alternative format)', 
      '[youtube]http://youtube.com/watch/v/E4Fbk52Mk1w[/youtube]',
      :video],
    'Google Video' => [
      /\[gvideo\](.*?)\?docid=([-]{0,1}\d+).*\[\/gvideo\]/i,
      '<embed style="width:400px; height:326px;" id="VideoPlayback" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId=\2" flashvars=""> </embed>',
      'Display a video from Google Video', 
      '[gvideo]http://video.google.com/videoplay?docid=-2200109535941088987[/gvideo]',
      :video]
  }
  def self.to_html(text, method = :disable, *tags)
    text = text.clone
    # escape < and > to remove any html
    text.gsub!( '<', '&lt;' )
    text.gsub!( '>', '&gt;' )
    
    # parse bbcode tags
    case method
      when :enable
        @@tags.each_value { |t|
          text.gsub!(t[0], t[1]) if tags.include?(t[4])
        }
      when :disable
        # this works nicely because the default is disable and the default set of tags is [] (so none disabled) :)
        @@tags.each_value { |t|
          text.gsub!(t[0], t[1]) unless tags.include?(t[4])
        }
    end
    
    # parse spacing
    text.gsub!( /\r\n?/, "\n" )
    text.gsub!( /\n/, "<br />" )
    
    # return markup
    text
  end
  
  def self.tags
    @@tags.each { |tn, ti|
      # yields the tag name, a description of it and example
      yield tn, ti[2], ti[3] if ti[2]
    }
  end
end


class String
  def bbcode_to_html(method = :disable, *tags)
    BBRuby.to_html(self, method, tags)
  end
  def bbcode_to_html!(method = :disable, *tags)
    self.replace(BBRuby.to_html(self, method, tags))
  end
end
