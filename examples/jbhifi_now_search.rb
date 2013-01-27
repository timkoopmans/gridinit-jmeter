$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'
require 'open-uri'

test do
 
   defaults(
    domain: 'now.jbhifi.com.au',
    protocol: 'https', 
    image_parser: true,
    concurrentDwn: true,
    embedded_url_re: '.+?now.((?!\$\{).)*$',
    concurrentPool: 4
  )

  header(
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.27 (KHTML, like Gecko) Chrome/26.0.1386.0 Safari/537.27',
    'Accept' => '*/*'
  )

  cache clear_each_iteration: true

  cookies
  
  threads 1, {loops: 1} do

    # random_timer 1000, 3000

    transaction 'jbhifi_home' do
      visit 'home', '/'
      visit 'choose', '/music/Home/Choose/?_=${__time(,)}', {
        follow_redirects: false,
        image_parser: true,
        embedded_url_re: 'none',
        } do
        header('X-Requested-With' => 'XMLHttpRequest')
        assert 'contains', 'WELCOME TO JB HI-FI NOW'
      end

    end

    transaction 'jbhifi_search_xhr' do
      get 'tgsearch', '/tgsearch/predictSearch.aspx?id=MD84-225&k=de' do
        header('X-Requested-With' => 'XMLHttpRequest')
      end
      get 'tgsearch', '/tgsearch/predictSearch.aspx?id=MD84-225&k=deado' do
        header('X-Requested-With' => 'XMLHttpRequest')
      end

      Loop 4 do
        counter

      end
      # get 'tgsearch', '/suggestwhere.ds?query=cockatoo' do
      #   extract 'random_suburb', '"key":"(.+?)"', {
      #     match_number: 0,
      #     template: '$1$'
      #   }
      # end
    end

    view_results

  end

# end.grid ARGV[1]
end.jmx
# end.run(path: '/usr/share/jmeter/bin/')