# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

alias ka='kubectl apply --recursive -f'
alias kgp='kubectl get pods -o wide'
alias kgpa='kubectl get pods -o wide -A'
alias kgpw='kubectl get pods -o wide -w'
alias kgpaw='kubectl get pods -o wide -A -w'
alias kgd='kubectl get deploy -o wide'
alias kgs='kubectl get service -o wide'
alias kgn='kubectl get node -o wide'
alias kgv='kubectl get pvc -o wide'
alias kd='kubectl describe'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
