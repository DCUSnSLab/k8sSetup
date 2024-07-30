CURRENT_USER=$(whoami)

CURRENT_HOSTNAME=$(hostname)

hostnamectl set-hostname $CURRENT_USER

echo $CURRENT_USER > /etc/hostname

sed -i "s/$CURRENT_HOSTNAME/$CURRENT_USER/g" /etc/hosts

echo "호스트 이름이 $CURRENT_HOSTNAME 에서 $CURRENT_USER 으로 변경되었습니다."

hostnamectl status
