
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

include $(core_path)/macros.mk

.PHONY: clean
clean:
	@_ROOT="${product_root}";_PNAME="${product_name}";if [ "$(test_root)" != "" ]; then _ROOT=$(test_root); _PNAME="${project_name}";fi; UNUSED="$(dep_dir) $(bin_dir) $(obj_dir) $(lib_dir) $${_ROOT}/run $${_ROOT}/gmon.out"; cleaned="no"; for i in $${UNUSED}; do if [ -e "$${i}" ]; then cleaned="yap"; rm -fr $${i}; fi; done; if [ "$${cleaned}" = "yap" ]; then $(CODE) "$${_PNAME}"; $(INFO) " - cleaned "; $(ENDL); fi; 


.PHONY: distclean
distclean: clean
	@for i in ${test_paths}; do make -C $$i clean --no-print-directory; done;
	@rm -f ${product_root}/test_results.txt
