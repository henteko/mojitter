require 'rubygems'
require './twitter_lib'
include Twitter_lib

$APP_NAME = "ruby_twitter"

###設定系###
login()
client = get_client()

###コマンドでの取得系###
name = get_name()
print "#{name} : #{$APP_NAME}$ "
while line = STDIN.gets
    case line
    when /exit/
        bye()
        break;
    when /tls/
        line = line.split(" ",2)
        case line.last
        when /-l/
            line = line.last.split(" ",2)
            if(line.last.to_i > 200)
                get_tl(200).each do |status|
                    puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                end
            else
                get_tl(line.last.to_i).each do |status|
                    puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                end
            end
        when /-@/
            line = line.last.split(" ",2)
            if(line.last.to_i > 200)
                get_at(200).each do |status|
                    puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                end
            else
                get_at(line.last.to_i).each do |status|
                    puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                end
            end
        else
            get_tl(20).each do |status|
                puts "  #{status.user.screen_name} >> "+"#{status['text']}"
            end
        end
    when /tup/
        line = line.split(" ",2)
        client.update(line.last)
    when /logout/
        print "twitter logout ok? y:n > "
        line = STDIN.gets
        if (/y/ =~ line)
            #yes
            logout()
            client = get_client()
            name = get_name()
        end
    else
        #なんでもないとき
        puts "#{line.chomp} is No Command"
    end
    print "#{name} : #{$APP_NAME}$ "
end
