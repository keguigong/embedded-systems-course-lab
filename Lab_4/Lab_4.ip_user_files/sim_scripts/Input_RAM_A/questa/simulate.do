onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Input_RAM_A_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {Input_RAM_A.udo}

run -all

quit -force
