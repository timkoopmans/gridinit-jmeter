$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gridinit-jmeter'

test do
  threads 1 do
    ldap_ext 'ldap_ext sample', 
      { 'test'       => 'sbind', 
        'user_dn'    => 'user_dn',
        'user_pw'    => 'user_password',
        'servername' => 'your_ldap_server',
        'secure'     => true,
        'port'       => 636
      }
  end
  view_results     'tree'
end.jmx

