#
# Cookbook Name:: zap
# Attributes:: users
#
# Author:: Sander Botman. <sbotman@schubergphilis.com>
#
# Copyright:: 2014, Sander Botman.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'debian'
  default['zap']['users']['keep'] = %w(
    root
    daemon
    bin
    sys
    sync
    games
    man
    lp
    mail
    news
    uucp
    proxy
    www-data
    backup
    list
    irc
    gnats
    nobody
    libuuid
    avahi-autoipd
    messagebus
    colord
    usbmux
    Debian-exim
    statd
    avahi
    pulse
    speech-dispatcher
    hplip
    sshd
    rtkit
    saned
    Debian-gdm
  )

when 'rhel', 'fedora'
  default['zap']['users']['keep'] = %w(
    root
    bin
    daemon
    adm
    lp
    sync
    shutdown
    halt
    mail
    uucp
    operator
    games
    gopher
    ftp
    nobody
    vcsa
    rpc
    ntp
    saslauth
    postfix
    rpcuser
    nfsnobody
    sshd
    dbus
    haldaemon
  )

when 'freebsd'
  default['zap']['users']['keep'] = %w(
    root
  )

else
  default['zap']['users']['keep'] = %w(
    root
  )
end
