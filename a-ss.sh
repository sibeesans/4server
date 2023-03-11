NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
domain=$(cat /usr/local/etc/xray/domain)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "               ${WB}Add Shadowsocks Account${NC}              "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -rp "User: " -e user
CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "               ${WB}Add Shadowsocks Account${NC}              "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${YB}nama klien sudah ada, coba pakai nama yang lain.${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -n 1 -s -r -p "Press any key to back on menu"
satriamenu 
fi
done
cipher="aes-256-gcm"
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#shadowsocks$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#shadowsocks-grpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
echo -n "$cipher:$uuid" | base64 -w 0 > /tmp/log
ss_base64=$(cat /tmp/log)
sslink1="ss://${ss_base64}@$domain:443?path=/shadowsocks&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
sslink2="ss://${ss_base64}@$domain:80?path=/shadowsocks&security=none&host=${domain}&type=ws#${user}"
sslink3="ss://${ss_base64}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=shadowsocks-grpc&sni=$domain#${user}"
rm -rf /tmp/log
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
cat > /var/www/html/shadowsocks/shadowsocks-$user.txt << END
END
systemctl restart xray
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━ [ Vip Shadowsocks ] ━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "Remarks       : $user" | tee -a /user/log-ss-$user.txt
echo -e "Domain        : $domain" | tee -a /user/log-ss-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-ss-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-ss-$user.txt
echo -e "Port Grpc     : 443" | tee -a /user/log-ss-$user.txt
echo -e "Port Tls      : 443" | tee -a /user/log-ss-$user.txt
echo -e "Port Ntls     : 80, 55" | tee -a /user/log-ss-$user.txt
echo -e "Cipher        : $cipher" | tee -a /user/log-ss-$user.txt
echo -e "Password      : $uuid" | tee -a /user/log-ss-$user.txt
echo -e "Network       : Websocket, gRPC" | tee -a /user/log-ss-$user.txt
echo -e "Path          : /shadowsocks" | tee -a /user/log-ss-$user.txt
echo -e "ServiceName   : shadowsocks-grpc" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "Link Tls      : $sslink1" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "Link Ntls     : $sslink2" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "Link Grpc     : $sslink3" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo -e "Expired       : $exp" | tee -a /user/log-ss-$user.txt
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /user/log-ss-$user.txt
echo " " | tee -a /user/log-ss-$user.txt
echo " " | tee -a /user/log-ss-$user.txt
echo " " | tee -a /user/log-ss-$user.txt
read -n 1 -s -r -p "Press any key to back on menu"
clear
satriamenu 
