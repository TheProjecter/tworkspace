
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

include $(MKF_DIR)/macros.mk

.PHONY: clean
clean:
	@UNUSED="$(BIN_DIR) $(OBJ_DIR) $(LIB_DIR) $(DEP_DIR) $(DEV_ROOT)/run $(DEV_ROOT)/gmon.out"; cleaned="no"; for i in $${UNUSED}; do if [ -e "$${i}" ]; then cleaned="yap"; rm -fr $${i}; fi; done; if [ "$${cleaned}" = "yap" ]; then $(INFO) "Cleaned "; $(ENDL); fi; 
