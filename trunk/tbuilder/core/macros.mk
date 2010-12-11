
define DONE
bash $(MKF_DIR)/scripts/done_message.sh $(MKF_DIR)/scripts/
endef

define INFO
bash $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ $1
endef

define CODE
bash $(MKF_DIR)/scripts/code.sh $(MKF_DIR)/scripts/ $1
endef

define ENDL
echo
endef
