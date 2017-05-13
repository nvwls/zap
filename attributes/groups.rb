#
# Cookbook Name:: zap
# Attributes:: groups
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
  default['zap']['groups']['keep'] = %w(
    root
    daemon
    bin
    sys
    adm
    tty
    disk
    lp
    mail
    news
    uucp
    man
    proxy
    kmem
    dialout
    fax
    voice
    cdrom
    floppy
    tape
    sudo
    audio
    dip
    www-data
    backup
    operator
    list
    irc
    src
    gnats
    shadow
    utmp
    video
    sasl
    plugdev
    staff
    games
    users
    nogroup
    libuuid
    crontab
    vboxsf
    fuse
    avahi-autoipd
    scanner
    messagebus
    colord
    lpadmin
    ssl-cert
    bluetooth
    utempter
    netdev
    Debian-exim
    mlocate
    ssh
    avahi
    pulse
    pulse-access
    rtkit
    saned
    Debian-gdm
  )

when 'rhel', 'fedora'
  default['zap']['groups']['keep'] = %w(
    root
    bin
    daemon
    sys
    adm
    tty
    disk
    lp
    mem
    kmem
    wheel
    mail
    uucp
    man
    games
    gopher
    video
    dip
    ftp
    lock
    audio
    nobody
    users
    utmp
    utempter
    floppy
    vcsa
    rpc
    cdrom
    tape
    dialout
    ntp
    saslauth
    postdrop
    postfix
    rpcuser
    nfsnobody
    sshd
    slocate
    haldaemon
    dbus
  )

when 'freebsd'
  default['zap']['groups']['keep'] = %w(
    root
  )

else
  default['zap']['groups']['keep'] = %w(
    root
  )
end
