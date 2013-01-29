$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do

  defaults :domain => 'www.etsy.com'

  cache :clear_each_iteration => true

  cookies
  
  threads 1, {:loops => 10} do

    random_timer 1000, 3000

    transaction '01_etsy_home' do
      visit 'home', 'http://www.etsy.com/' do
        assert 'contains', 'Etsy - Your place to buy and sell all things handmade, vintage, and supplies'
      end
    end

    once do
      transaction '02_etsy_signin' do
        submit 'signin', 'https://www.etsy.com/signin', {
          :fill_in => {
            :username =>   'tim.koops@gmail.com',
            :password =>   ARGV[0],
            :persistent => 1,
            :from_page =>  'http://www.etsy.com/',
            :from_action => '',
            :from_overlay => 1
          }
        } do
          assert 'contains', 'Tim'
          extract 'random_category', 'a href="(/browse.+?)"'
        end
      end
    end   

    exists 'random_category' do

      transaction '03_etsy_browse_random_category' do
        visit 'browse', '${random_category}' do
          extract 'random_sub_category', 'a href="(http.+?subcat.+?)"'
        end
      end

      transaction '04_etsy_browse_random_sub_category' do
        visit 'browse', '${random_sub_category}' do
          extract 'random_listing', 'a href="(/listing.+?)"'
        end
      end

      transaction '05_etsy_view_random_listing' do
        visit 'view', '${random_listing}'
      end

    end

  end

end.grid ARGV[1]
# end.jmx
# end.run(path: '/usr/share/jmeter/bin/')