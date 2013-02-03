$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'
require 'open-uri'

test do
 
   defaults(
    :domain => 'now.jbhifi.com.au',
    :protocol => 'https',
    :image_parser => true,
    :concurrentDwn => true,
    :embedded_url_re => '.+?now.((?!\$\{).)*$',
    :concurrentPool => 4
  )

  with_user_agent :iphone
  
  header(
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.27 (KHTML, like Gecko) Chrome/26.0.1386.0 Safari/537.27',
    'Accept' => '*/*'
  )

  cache :clear_each_iteration => true

  cookies
  
  threads 3, {:loops => 3} do

    random_timer 1000, 1500

    transaction 'jbhifi_home' do
      visit 'home', '/'
      visit 'choose', '/music/Home/Choose/?_=${__time(,)}', {
        :follow_redirects => false,
        :image_parser => true,
        :embedded_url_re => 'none',
        } do
        with_xhr
        assert 'contains', 'WELCOME TO JB HI-FI NOW'
      end

    end

    transaction 'jbhifi_search_xhr' do
      Loop 4 do
        counter
        bsh_pre(<<-EOS.strip_heredoc)
          String[] varArray = {"de", "dead", "deadma", "deadmau5"};
          idx = Integer.parseInt(vars.get("counter"))-1;
          vars.put("search_value", varArray[idx]);
        EOS
        get 'tgsearch', '/tgsearch/predictSearch.aspx?id=MD84-225&k=${search_value}' do
          with_xhr
        end
      end
    end

    transaction'jbhifi_search' do
      post 'search', '/music/Search/Search', {
        :fill_in => {
          'searchType'  => 'KW',
          'keyword'     => 'deadmau5',
          'numRecords'  => 25
        }
      } do 
        with_xhr
        extract 'id', '"c":"(.+?)"', {
          :match_number => 0,
          :template => '$1$'
        }
      end
    end

    transaction'jbhifi_add_to_playlist' do
      post 'playlist', '/music/Playlist/AddPreview/', {
        :fill_in => {
          'id'  => '${id}'
        }
      } do 
        with_xhr
        extract 'mp3', '"mp3":"(.+?)"', {
          :match_number => 0,
          :template => '$1$'
        }
      end
    end

    exists 'mp3' do
      transaction'jbhifi_preview_track' do
        get 'preview', '${mp3}'
      end
    end

    view_results

  end

# end.grid ENV['API_TOKEN']
end.jmx
# end.run(path: '/usr/share/jmeter/bin/')