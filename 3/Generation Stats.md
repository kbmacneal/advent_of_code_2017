Stats for how long it takes to generate a ring of size N
	
~~~~
PS C:\Powershell\gitrepo\advent_of_code_2017\3> measure-command { new-spiral -max_ring_size 50}


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 3
Milliseconds      : 272
Ticks             : 32723757
TotalDays         : 3.787471875E-05
TotalHours        : 0.00090899325
TotalMinutes      : 0.054539595
TotalSeconds      : 3.2723757
TotalMilliseconds : 3272.3757
	
~~~~

	
~~~~
PS C:\Powershell\gitrepo\advent_of_code_2017\3> measure-command { new-spiral -max_ring_size 100}


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 13
Milliseconds      : 662
Ticks             : 136623707
TotalDays         : 0.000158129290509259
TotalHours        : 0.00379510297222222
TotalMinutes      : 0.227706178333333
TotalSeconds      : 13.6623707
TotalMilliseconds : 13662.3707
	
~~~~

	
~~~~
PS C:\Powershell\gitrepo\advent_of_code_2017\3> measure-command { new-spiral -max_ring_size 500}


Days              : 0
Hours             : 0
Minutes           : 22
Seconds           : 22
Milliseconds      : 709
Ticks             : 13427091556
TotalDays         : 0.0155406152268519
TotalHours        : 0.372974765444444
TotalMinutes      : 22.3784859266667
TotalSeconds      : 1342.7091556
TotalMilliseconds : 1342709.1556
	
~~~~
