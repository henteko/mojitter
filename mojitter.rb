require 'rubygems'
require './twitter_lib'
include Twitter_lib

$APP_NAME = "mojitter"

###設定系###
if defined?(ARGV[0])
    set_proxy(ARGV[0],ARGV[1])
else
    set_proxy(nil,nil)
end
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
        puts "-------------------------------------------"
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
        puts "-------------------------------------------"
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
