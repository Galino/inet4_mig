package inet.examples.bgpv4.Bgp2RoutersInASEdit;

import inet.common.misc.ThruputMeteringChannel;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.bgp.BgpRouter;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;
import inet.node.ospfv2.OspfRouter;


network BGPTest
{
    types:
        channel LINK_100 extends ThruputMeteringChannel
        {
            parameters:
                delay = 0s;
                datarate = 100Mbps;
                thruputDisplayFormat = "#N";
        }
    submodules:
        A1: BgpRouter {
            parameters:
                @display("p=700,230");
            gates:
                pppg[2];
        }
        A2: BgpRouter {
            parameters:
                @display("p=850,230");
            gates:
                pppg[2];
        }
        B: BgpRouter {
            parameters:
                @display("p=700,130");
            gates:
                pppg[2];
        }
        C: BgpRouter {
            parameters:
                @display("p=850,130");
            gates:
                pppg[3];
        }
        RA1: OspfRouter {
            parameters:
                @display("p=700,330;i=device/router");
            gates:
                pppg[3];
        }
        RA2: OspfRouter {
            parameters:
                @display("p=850,330;i=device/router");
            gates:
                pppg[3];
        }
        RA3: OspfRouter {
            parameters:
                @display("p=775,430;i=device/router");
            gates:
                pppg[2];
                ethg[1];
        }
        RB1: OspfRouter {
            parameters:
                @display("p=550,130;i=device/router");
            gates:
                pppg[1];
                ethg[1];
        }
        RC1: OspfRouter {
            parameters:
                @display("p=1000,130;i=device/router");
            gates:
                pppg[2];
                ethg[1];
        }
        RC2: OspfRouter {
            parameters:
                @display("p=1000,330;i=device/router");
            gates:
                pppg[2];
                ethg[1];
        }
        PA3: EtherSwitch {
            parameters:
                @display("p=775,530;i=device/switch");
            gates:
                ethg[3];
        }
        PB1: EtherSwitch {
            parameters:
                @display("p=400,130;i=device/switch");
            gates:
                ethg[3];
        }
        PC1: EtherSwitch {
            parameters:
                @display("p=1150,130;i=device/switch");
            gates:
                ethg[3];
        }
        PC2: EtherSwitch {
            parameters:
                @display("p=1150,330;i=device/switch");
            gates:
                ethg[3];
        }
        HA31: StandardHost {
            parameters:
                @display("p=700,630;i=device/pc");
            gates:
                ethg[1];
        }
        HA32: StandardHost {
            parameters:
                @display("p=850,630;i=device/pc");
            gates:
                ethg[1];
        }
        HB11: StandardHost {
            parameters:
                @display("p=250,80;i=device/pc");
            gates:
                ethg[1];
        }
        HB12: StandardHost {
            parameters:
                @display("p=250,180;i=device/pc");
            gates:
                ethg[1];
        }
        HC11: StandardHost {
            parameters:
                @display("p=1300,80;i=device/pc");
            gates:
                ethg[1];
        }
        HC12: StandardHost {
            parameters:
                @display("p=1300,180;i=device/pc");
            gates:
                ethg[1];
        }
        HC21: StandardHost {
            parameters:
                @display("p=1300,280;i=device/pc");
            gates:
                ethg[1];
        }
        HC22: StandardHost {
            parameters:
                @display("p=1300,380;i=device/pc");
            gates:
                ethg[1];
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=100,100;is=s");
            config = xmldoc("IPv4Config.xml");
            //assignAddresses = false;
            //assignDisjunctSubnetAddresses = false;
            addStaticRoutes = false;
            addDefaultRoutes = false;
            addSubnetRoutes = false;
        }
    connections:
        //LAN RA3
        HA31.ethg[0] <--> LINK_100 <--> PA3.ethg[0];
        HA32.ethg[0] <--> LINK_100 <--> PA3.ethg[1];
        PA3.ethg[2] <--> LINK_100 <--> RA3.ethg[0];

        //LAN RB1
        HB11.ethg[0] <--> LINK_100 <--> PB1.ethg[0];
        HB12.ethg[0] <--> LINK_100 <--> PB1.ethg[1];
        PB1.ethg[2] <--> LINK_100 <--> RB1.ethg[0];

        //LAN C1 et C2
        HC11.ethg[0] <--> LINK_100 <--> PC1.ethg[0];
        HC12.ethg[0] <--> LINK_100 <--> PC1.ethg[1];
        HC21.ethg[0] <--> LINK_100 <--> PC2.ethg[0];
        HC22.ethg[0] <--> LINK_100 <--> PC2.ethg[1];
        PC1.ethg[2] <--> LINK_100 <--> RC1.ethg[0];
        PC2.ethg[2] <--> LINK_100 <--> RC2.ethg[0];

        //OSPF A
        RA1.pppg[2] <--> LINK_100 <--> RA3.pppg[0];
        RA2.pppg[2] <--> LINK_100 <--> RA3.pppg[1];
        RA1.pppg[1] <--> LINK_100 <--> RA2.pppg[1];
        RA1.pppg[0] <--> LINK_100 <--> A1.pppg[1];
        RA2.pppg[0] <--> LINK_100 <--> A2.pppg[1];

        //OSPF B
        RB1.pppg[0] <--> LINK_100 <--> B.pppg[1];

        //OSPF C
        RC1.pppg[1] <--> LINK_100 <--> RC2.pppg[1];
        RC1.pppg[0] <--> LINK_100 <--> C.pppg[1];
        RC2.pppg[0] <--> LINK_100 <--> C.pppg[2];

        //BGP
        A1.pppg[0] <--> LINK_100 <--> B.pppg[0];
        A2.pppg[0] <--> LINK_100 <--> C.pppg[0];
}

