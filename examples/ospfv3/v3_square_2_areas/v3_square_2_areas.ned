package inet.examples.ospfv3.v3_square_2_areas;

import inet.node.ospfv3.Ospfv3Router;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.configurator.ipv6.Ipv6FlatNetworkConfigurator;
import inet.common.misc.ThruputMeteringChannel;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;


network v3_square_2_areas
{
    types:
        channel Channel extends ThruputMeteringChannel
        {
            delay = 0.1us;
            datarate = 100Mbps;
            thruputDisplayFormat = "#N";
        }
    submodules:
        configurator: Ipv4NetworkConfigurator {
            parameters:
                //                            "<interface among='Router1 Router2' address='10.10.10.x' netmask='255.255.255.0' />"+
                //                            "<interface among='Router2 Router3' address='10.10.20.x' netmask='255.255.255.0' />"+
                config = xml("<config>"+
//                            "<interface among='Router1 Router2' address='10.10.10.x' netmask='255.255.255.0' />"+
//                            "<interface among='Router2 Router3' address='10.10.20.x' netmask='255.255.255.0' />"+
//                             "<interface among='Router1 Host1' address='172.16.10.x' netmask='255.255.255.0' />"+
                            "</config>");
                addStaticRoutes = false;
                addDefaultRoutes = false;
                addSubnetRoutes = false;
                @display("p=147,54");
        }
        Router1: Ospfv3Router {
            parameters:
                @display("p=101,256");
            gates:
                ethg[3];
        }
        Router2: Ospfv3Router {
            parameters:
                @display("p=116,115");
            gates:
                ethg[2];
        }
        Router3: Ospfv3Router {
            parameters:
                @display("p=341,115");
            gates:
                ethg[2];
        }
        Router4: Ospfv3Router {
            parameters:
                @display("p=341,256");
            gates:
                ethg[2];
        }
        Host1: StandardHost {
            @display("p=29,260");
            gates:
                ethg[1];
        }

    connections:
        Router1.ethg[0] <--> Channel <--> Router2.ethg[0];
        Router2.ethg[1] <--> Channel <--> Router3.ethg[0];
        Router3.ethg[1] <--> Channel <--> Router4.ethg[1];
        Router4.ethg[0] <--> Channel <--> Router1.ethg[1];
        Router1.ethg[2] <--> Channel <--> Host1.ethg[0];



}
