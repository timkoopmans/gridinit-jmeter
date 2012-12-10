$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do

  threads 100 do

    visit 'Google', "http://google.com/" do
      extract 'button_text', 'aria-label="(.+?)"'
      extract :regex, 'button_text', 'aria-label="(.+?)"'
      extract :xpath, 'button', '//buton'
    end

  end

end.jmx