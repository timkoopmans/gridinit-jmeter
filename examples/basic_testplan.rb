$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads(num_threads: 100) do
    transaction(name: 'First time visitor') do
      visit(url: 'http://127.0.0.1:4567/') do
        extract(name: 'csrf-token', regex: "content='(.+?)' name='csrf-token'")
      end

      submit(
        url: 'http://127.0.0.1:4567/',
        args: {
          username: 'tim',
          password: 'password',
          'csrf-token' => '${csrf-token}'
        }
      ) 
    end
  end
end.jmx