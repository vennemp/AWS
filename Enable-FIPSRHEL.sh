yum update -y
grep -qw aes /proc/cpuinfo && echo YES || echo no
yum install dracut-fips-aesni
rpm -q prelink && sed -i ‘/^PRELINKING/s,yes,no,’ /etc/sysconfig/prelink
rpm -q prelink && prelink -uav
rpm -q prelink && sed -i ‘/^PRELINKING/s,yes,no,’ /etc/sysconfig/prelink
mv -v /boot/initramfs-$(uname -r).img{,.bak}
dracut
grubby --update-kernel=$(grubby --default-kernel) --args=fips=1
uuid=$(findmnt -no uuid /boot)
[[ -n $uuid ]] && grubby --update-kernel=$(grubby --default-kernel) --args=boot=UUID=${uuid}
reboot
