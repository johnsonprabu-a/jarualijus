# Example settings for dnsmasq.
dnsmasq:
  dnsmasq_conf: salt://dnsmasq/files/dnsmasq.conf
  dnsmasq_hosts: salt://dnsmasq/files/dnsmasq.hosts
  dnsmasq_cnames: salt://dnsmasq/files/dnsmasq.cnames
  dnsmasq_addresses: salt://dnsmasq/files/dnsmasq.addresses
  dnsmasq_conf_dir: salt://dnsmasq/files/dnsmasq.d

  # Customize dnsmasq settings below - any valid dnsmasq configuration file
  # parameter may be included. One setting per line.
  #
  # Note that on/off settings are handled differently. If the option does not
  # appear in the config file, it is disabled. If it does appear, the option is
  # enabled. To enable an option, set it to "True". For example:
  #     domain-needed: True
  #
  # Options which may be listed multiple times in the configuration file
  # (e.g., interface) must be passed as lists.
  #
  settings:
    # Port to listen on. Setting this to zero completely disables DNS function,
    # leaving only DHCP and/or TFTP.
    port: 53

    # Listen only on the eth1 and lo interfaces
#    interface:
#      - eth1
#      - lo

    # Require full domain name? (including a dot and domain part)
    domain-needed: True
    # Never forward addresses in the non-routed address spaces?
    bogus-priv: True

  # Add extra entries to the DNS or override existing ones
  # (e.g. for split horizon usage)
  # The domain will automatically be appended if its part of a mapping
  # It is recommended to group common domains in a mapping to prevent
  # duplicated names in Pillar and to make it easier to manage.
  hosts:
    jarualijus.com:
      dns: 10.10.10.1
      vpn: 10.10.10.2
    jarualijus.net:
      www: 10.10.10.3
      mail: 10.10.10.4
    test.jarualijus.org: 10.10.10.5

  # CNAME handling
  # Similarly to hosts this can deal with single and multiple entries in the
  # form of source: target.
  # Please note that this _only_ works for targets that are in the DHCP or
  # /etc/hosts (Pillarized hosts included)
  cnames:
    vpn.jarualijus.biz: vpn.jarualijus.com
    jarualijus.org:
      vpn: vpn.jarualijus.com
      mail: mail.jarualijus.net

  # Add domains which you want to force to an IP address here.
  addresses:
    double-click.net: 127.0.0.1
    www.thekelleys.org.uk: "fe80::20d:60ff:fe36:f83"
