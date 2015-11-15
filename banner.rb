require 'rubygems'
require 'rmagick'
require 'pp'
require 'chronic'

r = Hash.new

Magick::Image.read('boldergruen.png')[0].each_pixel do |pixel, col, row|
  r[[col,row]] = case pixel.to_HSL[2]*100
                  when 0..20 # 1.7
                    4
                  when 20..40 # 33
                    3
                  when 40..60 # 56
                    2
                  when 60..85 # 81
                    1
                  else        # 100
                    0
                  end
end


start_date = DateTime.parse("Oct 4 2015 06:00")
dates = Hash.new

r.each do |k,v|
  week_offset = k[0] * 7 # column is week
  day_offset =  k[1]     # row is day
  draw_here = start_date + week_offset + day_offset
  unless v == 0 
    dates[[k[0],k[1]]] = [v, draw_here]
  end
end

f = File.open('commands.txt', 'w')

dates.each do |k,v|
  b = v[0] # shade value
  dt = v[1] # date to shade
    
  unless b == 0
    ((b+1)*2).times do
      f.write "mkdir -p #{dt.strftime('%Y/%m')}\n"
      f.write "touch #{dt.strftime('%Y/%m')}/#{b}-#{dt.strftime('%Y-%m-%d-%H')}.roffles" + "\n"
      f.write "git add ." + "\n"
      f.write "git commit --date=\"#{dt.strftime('%a %b %d %H:%M %Y -0400')} -0400\" -m \"srsbznss on #{dt.strftime('%Y-%m-%d-%H')}\"" + "\n"
      dt = dt+0.05 
    end
  end
end

f.close
