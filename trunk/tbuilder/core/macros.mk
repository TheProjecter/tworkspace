
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Author Tigran Hovhannisyan - tigran.co.cc

bash    := /bin/bash

define DONE
$(bash) $(MKF_DIR)/scripts/done_message.sh $(MKF_DIR)/scripts/
endef

define INFO
$(bash) $(MKF_DIR)/scripts/info.sh $(MKF_DIR)/scripts/ $1
endef

define CODE
$(bash) $(MKF_DIR)/scripts/code.sh $(MKF_DIR)/scripts/ $1
endef

define ERROR
$(bash) $(MKF_DIR)/scripts/error.sh $(MKF_DIR)/scripts/ $1
endef

define ENDL
echo
endef
