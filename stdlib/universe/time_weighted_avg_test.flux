package universe_test


import "testing"
import "csv"

option now = () => 2030-01-01T00:00:00Z

inData =
    "
#datatype,string,long,dateTime:RFC3339,string,string,double
#group,false,false,false,true,true,false
#default,_result,,,,,
,result,table,_time,_measurement,_field,_value
,,0,2018-05-22T19:53:00Z,_m,FF,2
,,0,2018-05-22T19:53:10Z,_m,FF,2
,,0,2018-05-22T19:53:20Z,_m,FF,4
,,0,2018-05-22T19:53:30Z,_m,FF,6
,,0,2018-05-22T19:53:40Z,_m,FF,8
,,0,2018-05-22T19:53:50Z,_m,FF,10
,,1,2018-05-22T19:53:10Z,_m,QQ,1
,,1,2018-05-22T19:53:20Z,_m,QQ,1
,,1,2018-05-22T19:53:30Z,_m,QQ,1
,,1,2018-05-22T19:53:40Z,_m,QQ,1
,,2,2018-05-22T19:53:10Z,_m,RR,3
,,2,2018-05-22T19:53:30Z,_m,RR,0
"
outData =
    "
#datatype,string,long,string,string,double
#group,false,false,true,true,false
#default,_result,,,,
,result,table,_measurement,_field,_value
,,0,_m,FF,6
,,1,_m,QQ,1
,,2,_m,RR,1
"

testcase twa_test {
    got =
        csv.from(csv: inData)
            |> testing.load()
            |> range(start: 2018-05-22T19:53:00Z, stop: 2018-05-22T19:54:00Z)
            |> timeWeightedAvg(unit: 10s)
            |> drop(columns: ["_start", "_stop"])
    want = csv.from(csv: outData)

    testing.diff(got, want)
}
