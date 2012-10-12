require 'rubygems'
require 'twitter'
require 'oauth'

module Twitter_lib

    $CONSUMER_KEY = "YOU_CONSUMER_KEY"
    $CONSUMER_SECRET = "YOU_CONSUMER_SECRET"

    MultiJson.engine = :ok_json
    $oauth_token_filename = 'data1.dat'
    $oauth_token_filename = File.expand_path(File.expand_path(__FILE__) + '../../../config/' + $oauth_token_filename)
    $oauth_token_secret_filename = 'data2.dat'
    $oauth_token_secret_filename = File.expand_path(File.expand_path(__FILE__) + '../../../config/' + $oauth_token_secret_filename)

    $oauth_token = ''
    $oauth_token_secret = ''

    $client
    $screen_name
    $PROXY_ADDR
    $PROXY_PORT
    def set_proxy(addr,port)
        $PROXY_ADDR = addr
        $PROXY_PORT = port
    end
    def login()
        if (oauth_file_check() == false)
            oauth_set()
        end
        client_set()
        #welcome()
    end
    def login_bash()
        if(oauth_file_check())
            client_set()
            return true
        else
            return false 
        end
    end

    def oauth_file_check()
        begin
            File.open($oauth_token_filename,'r+'){ |file|
                $oauth_token = Marshal.load(file)
            }
            File.open($oauth_token_secret_filename,'r+'){ |file|
                $oauth_token_secret = Marshal.load(file)
            }
            if ($oauth_token_secret == '' || $oauth_token == '')
                return false
            end
            return true
        rescue
            #fileがなかったりエラーが起きたとき
            return false
        end
    end

    def oauth_set()
        consumer = OAuth::Consumer.new($CONSUMER_KEY, $CONSUMER_SECRET, :site => "http://twitter.com")

        request_token = consumer.get_request_token
        # twitterに対してrequestトークンを要求

        puts "Access this URL and approve => #{request_token.authorize_url}"

        print "Input OAuth Verifier: "
        oauth_verifier = $stdin.gets.chomp.strip
        # 許可後した後に表示された数字を入力してください

        access_token = request_token.get_access_token(  :oauth_verifier => oauth_verifier)
        $oauth_token = access_token.token
        $oauth_token_secret = access_token.secret

        File.open($oauth_token_filename,'w+'){ |file|
            Marshal.dump($oauth_token, file)
        }
        File.open($oauth_token_secret_filename,'w+'){ |file|
            Marshal.dump($oauth_token_secret, file)
        }
    end

    def client_set()
        if $PROXY_ADDR.nil?
            Twitter.configure do |config|
                config.consumer_key = $CONSUMER_KEY
                config.consumer_secret = $CONSUMER_SECRET
                config.oauth_token = $oauth_token
                config.oauth_token_secret = $oauth_token_secret
            end
        else
            Twitter.configure do |config|
                config.consumer_key = $CONSUMER_KEY
                config.consumer_secret = $CONSUMER_SECRET
                config.oauth_token = $oauth_token
                config.oauth_token_secret = $oauth_token_secret
                config.proxy = "http://" + $PROXY_ADDR + ":" + $PROXY_PORT
            end
        end
        $client = Twitter::Client.new
        $screen_name = $client.user.screen_name
    end

    def logout()
        File.open($oauth_token_filename,'w+'){ |file|
            Marshal.dump("", file)
        }
        File.open($oauth_token_secret_filename,'w+'){ |file|
            Marshal.dump("", file)
        }
        print "Logout OK!!"

        print "next twitter login? y:n > "
        line = STDIN.gets
        if (/y/ =~ line)
            #yes
            login()
            welcome()
        end
    end

    def welcome()
        puts "@#{$screen_name} Hello!!"
    end

    def bye()
        puts "@#{$screen_name} Bye!!"
    end

    def get_client()
        return $client
    end

    def get_tl(num)
        return $client.home_timeline({:count => num})
    end

    def get_pb_tl(num)
        return $client.public_timeline({:count => num})
    end

    def get_at(num)
        return $client.mentions({:count => num})
    end

    def get_name()
        return $screen_name
    end
end
