let
  # Hardware
  cpuMon = "hwmon1";
  cpuName = "k10temp";
  cpuPath = "devices/pci0000:00/0000:00:18.3";
  fanMon = "hwmon4";
  fanName = "nct6686";
  fanPath = "devices/platform/nct6687.2592";
  # Fan speeds -- value = percent * 2.55
  caseMin = "100"; # 40%
  caseMax = "102"; # 40%
  cpuMin = "64"; # 25%
  cpuMax = "217"; # 85%
in
''
  INTERVAL=10
  DEVPATH=${cpuMon}=${cpuPath} ${fanMon}=${fanPath}
  DEVNAME=${cpuMon}=${cpuName} ${fanMon}=${fanName}
  FCTEMPS=${fanMon}/pwm1=${cpuMon}/temp1_input ${fanMon}/pwm2=${cpuMon}/temp1_input
  FCFANS=${fanMon}/pwm1=${fanMon}/fan1_input ${fanMon}/pwm2=${fanMon}/fan2_input
  MINTEMP=${fanMon}/pwm1=40 ${fanMon}/pwm2=40
  MAXTEMP=${fanMon}/pwm1=80 ${fanMon}/pwm2=80
  MINSTART=${fanMon}/pwm1=30 ${fanMon}/pwm2=30
  MINSTOP=${fanMon}/pwm1=${cpuMin} ${fanMon}/pwm2=${caseMin}
  # Fans @ 25%/40% until 40 degress
  MINPWM=${fanMon}/pwm1=${cpuMin} ${fanMon}/pwm2=${caseMin}
  # CPU fan ramps to 85% @ 80 degrees
  MAXPWM=${fanMon}/pwm1=${cpuMax} ${fanMon}/pwm2=${caseMax}
''
