
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
	@$(INFO) " Cleaning ... "
	@rm -fr $(BIN_DIR)
	@rm -fr $(OBJ_DIR)
	@rm -fr $(LIB_DIR)
	@rm -fr $(DEP_DIR)
	@rm -fr $(DEV_ROOT)/run
	@rm -fr $(DEV_ROOT)/gmon.out
	@$(DONE)
