require 'rubygems'
require 'net/ldap'
require 'readline'

#timelimit 120
#bind_timelimit 120
#idle_timelimit 3600
#ssl no
#tls_cacertdir /etc/openldap/cacerts
#pam_password md5
#pam_filter |(memberOf=CN=dell-crowbar-eng,ou=groups,o=mirantis,dc=mirantis,dc=net)
#sudoers_base ou=sudoers,dc=mirantis,dc=net
#uri ldap://ns ldap://ns2
#bind_policy soft
#nss_initgroups_ignoreusers apt-cacher-ng,backup,bin,daemon,ftp,games,gnats,irc,landscape,libuuid,libvirt-dnsmasq,libvirt-qemu,list,lp,mail,man,messagebus,news,nslcd,ntp,privoxy,proftpd,proxy,root,sshd,sync,sys,syslog,uucp,whoopsie,www-data


user_name = "eshurmin"

treebase = "dc=mirantis,dc=net"
ldap = Net::LDAP.new( :host => "ns" )

filter = Net::LDAP::Filter.eq("uid", user_name)
attrs = ["mail", "cn", "sn", "objectclass"]
user_entry = ldap.search(:base => treebase, :filter => filter, :attributes => attrs).first
puts "DN: #{user_entry.dn}"

ldap.auth user_entry.dn, "password"

if ldap.bind
  puts "authentication succeeded"
else
  puts ldap.get_operation_result
end
