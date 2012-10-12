require 'rubygems'
require File.dirname(__FILE__) + '/lib/twitter_lib'
include Twitter_lib

$APP_NAME = "mojitter"

###設定系###

if (ARGV[0] == '-login') 
    login()
    welcome()
elsif (ARGV[0] == '-logout')
    logout()
elsif (ARGV[0] == '-bash')
    if(login_bash())
        print "#{get_name()} : "
        get_tl(1).each do |status|
            puts " #{status.user.screen_name} >> "+"#{status['text']}"
        end
    else
        print "mojitter no login!!"
    end 
else
    login()
    welcome()
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
            when /-stsp/
                get_pb_tl(200).each do |status|
                    case status['source']
                    when /<a href="http:\/\/shootingstar067.com\/" rel="nofollow">ShootingStar<\/a>/
                        puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                    end
                end
            when /-sts/
                get_tl(200).each do |status|
                    case status['source']
                    when /<a href="http:\/\/shootingstar067.com\/" rel="nofollow">ShootingStar<\/a>/
                        puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                    end
                end
            when /-name/
                line = line.last.split(" ",2)
                fav_search_name = line.last.chomp
                get_tl(10).each do |status|
                    fav_name = status.user.screen_name
                    if(fav_name == fav_search_name && fav(status['id'], false))
                        puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                    end
                end
            when /-fav_time/
                line = line.last.split(" ")
                fav_time = line[1].to_i
                fav_search_name = line[2].chomp
                begin
                    timeout(fav_time) {
                        while(1)
                            get_tl(1).each do |status|
                                fav_name = status.user.screen_name
                                if(fav_name == fav_search_name && fav(status['id'], false))
                                    puts "  #{status.user.screen_name} >> "+"#{status['text']}"
                                end
                            end
                            sleep 1
                        end
                    }
                rescue
                    puts "end fav time"
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
end
