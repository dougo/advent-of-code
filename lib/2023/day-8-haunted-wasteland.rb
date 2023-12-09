=begin

--- Day 8: Haunted Wasteland ---

One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to
navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of
left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.

It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the
camel follow the same instructions, you can escape the haunted wasteland!

After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and
you have to follow the left/right instructions until you reach ZZZ.

This format defines each node of the network individually. For example:

RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)

Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In
this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose
the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.

Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence
of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that
takes 6 steps to reach ZZZ:

LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)

Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?

--- Part Two ---

The sandstorm is upon you and you aren't any closer to escaping the wasteland. You had the camel follow the
instructions, but you've barely left your starting position. It's going to take significantly more steps to escape!

What if the map isn't for people - what if the map is for ghosts? Are ghosts even bound by the laws of spacetime?
Only one way to find out.

After examining the maps a bit longer, your attention is drawn to a curious fact: the number of nodes with names
ending in A is equal to the number ending in Z! If you were a ghost, you'd probably just start at every node that
ends with A and follow all of the paths at the same time until they all simultaneously end up at nodes that end
with Z.

For example:

LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)

Here, there are two starting nodes, 11A and 22A (because they both end with A). As you follow each left/right
instruction, use that instruction to simultaneously navigate away from both nodes you're currently on. Repeat this
process until all of the nodes you're currently on end with Z. (If only some of the nodes you're on end with Z,
they act like any other node and you continue as normal.) In this example, you would proceed as follows:

Step 0: You are at 11A and 22A.
Step 1: You choose all of the left paths, leading you to 11B and 22B.
Step 2: You choose all of the right paths, leading you to 11Z and 22C.
Step 3: You choose all of the left paths, leading you to 11B and 22Z.
Step 4: You choose all of the right paths, leading you to 11Z and 22B.
Step 5: You choose all of the left paths, leading you to 11B and 22C.
Step 6: You choose all of the right paths, leading you to 11Z and 22Z.

So, in this example, you end up entirely on nodes that end in Z after 6 steps.

Simultaneously start on every node that ends with A. How many steps does it take before you're only on nodes that
end with Z?

=end

class HauntedWasteland
  def initialize(text)
    @left_right, _, *network_lines = text.lines(chomp: true)
    @network = network_lines.map do |line|
      line =~ /(...) = \((...), (...)\)/
      [$1, { "L" => $2, "R" => $3 }]
    end.to_h
  end

  def next_index(index)
    (index + 1) % @left_right.length
  end

  def instruction(index)
    @left_right[index]
  end

  def nodes
    @network.keys
  end

  def next_node(node, index)
    @network[node][instruction(index)]
  end

  State = Struct.new(:node, :index) do
    def self.start(node = 'AAA')
      new(node, 0)
    end

    def next(hw)
      self.class.new(hw.next_node(node, index), hw.next_index(index))
    end

    def end?
      node == 'ZZZ'
    end

    def path_to_end(hw)
      path = [self]
      path << path.last.next(hw) until path.last.end?
      path
    end
  end

  def steps_required(state = State.start)
    state.path_to_end(self).length - 1
  end

  class GhostState < State
    def end?
      node.end_with? 'Z'
    end
  end

  def steps_required_for_ghosts
    starts = nodes.filter_map { GhostState.start(_1) if _1.end_with? 'A' }

    # TODO: this happens to work for the given input, but it really should figure out the cycle lengths properly.
    starts.map { steps_required(_1) }.reduce(:lcm)
  end
end

if defined? DATA
  hw = HauntedWasteland.new(DATA.read)
  puts hw.steps_required
  puts hw.steps_required_for_ghosts
end

__END__
LRRLRRRLRRLLLRLLRRLRRLLRRRLRRLLRLRRRLRLRRLRLRRRLRLRLRRLLRLRLRRLRRRLRRRLRRRLRLRRLLLLRLLRLLRRLRRRLLLRLRRRLRLRRRLRLRRLRRRLRRRLRLRLLRRRLLRLLRLRLRLRLLRRLRRLRRRLRRLRLRLRLRLRRLRRRLLRRRLLRLLLRRRLLRRRLRRRLRRLRLRRLRLLRRLLRRLRLRLRRLRLRRLLRRRLLRRRLLRLRRRLRLRRRLRLRRRLRRRLRRLRRLRRLLRRRLRRRLLLRRRR

RGT = (HDG, QJV)
QDM = (GPB, SXG)
DJN = (TQD, BQN)
QGG = (GGS, PTC)
FJP = (MPB, HFP)
KNB = (QHC, XBQ)
RGR = (LSQ, LJV)
HDP = (RLT, LRK)
DBQ = (KTM, MPJ)
QSG = (QVF, QVF)
JKR = (XTK, RQB)
BJH = (VKC, SML)
LRF = (NPJ, HKK)
JRD = (BQX, LGK)
HVD = (CJP, TLM)
VCG = (JMS, RJB)
PCT = (KJC, RCQ)
DRK = (PTR, FSH)
BJN = (GVD, XXN)
CXL = (FMB, NKM)
TVM = (TTX, RCG)
PTP = (KQQ, XLR)
CKX = (VKR, RDH)
TCP = (TPX, BSB)
KSC = (JFL, CHL)
DTF = (BTQ, TTQ)
GFQ = (HKK, NPJ)
BKD = (CXB, JSB)
DJB = (TMG, DDQ)
CQV = (SSX, DFT)
BPC = (KNR, CGF)
KLT = (BMF, XQC)
NLB = (DBD, VCL)
HJS = (FXK, FLB)
PSL = (PBC, XFX)
LVL = (JFD, RJD)
JMX = (CGG, RRL)
TTQ = (XVC, RCT)
NLG = (FXK, FLB)
LCD = (JSB, CXB)
HVR = (CRV, HHM)
HGV = (VCG, JDT)
LND = (TTL, QCH)
CSX = (DHS, JLB)
BRJ = (BCT, XFS)
XVN = (RDH, VKR)
HQB = (BVD, GPC)
PGP = (CFB, HQL)
NFB = (BDX, JDK)
HJK = (VVX, HTP)
KKB = (NSF, GPP)
JDV = (XJG, FDR)
VGC = (HFV, JMT)
BBG = (GTF, KTP)
HTB = (BTC, KKC)
KPL = (MXJ, MBN)
NHD = (GCT, TGP)
DMP = (KRH, SPM)
LRB = (GNP, GGB)
BGA = (MPB, HFP)
PBZ = (KXQ, CKP)
BQF = (LJC, VGC)
KKC = (DJB, MCS)
RRL = (QCK, RKN)
PDZ = (RGF, BHL)
SLA = (BCD, VJK)
XRC = (SKL, VBP)
HHM = (HSJ, NTR)
BNP = (GPP, NSF)
GHM = (HLC, KQK)
LMV = (VTS, NFQ)
QKF = (JNG, THN)
PCG = (HSQ, DMP)
CKG = (XSX, RDF)
RMV = (FQL, HJL)
LPG = (RJD, JFD)
HFJ = (VQX, LQZ)
QRF = (BCR, VSV)
JSR = (BJJ, DVJ)
TKS = (KTP, GTF)
JNG = (DJD, XLM)
XDG = (JKR, MRR)
PFB = (QLT, PBD)
NTR = (HBV, NRX)
NMN = (BDX, JDK)
MGP = (QMT, VLG)
PTA = (LSP, TXX)
CRK = (CJP, TLM)
NVL = (STQ, QFH)
VCL = (XFD, MGN)
LJM = (VJH, NXV)
GCJ = (RFS, QLN)
NSF = (TKV, LKQ)
PQN = (QHC, XBQ)
GHK = (FNT, LCX)
SFK = (FQL, HJL)
FNX = (VXK, BJN)
SSX = (MGK, KRX)
FSH = (FNB, QFL)
XFS = (BCK, CKG)
VLQ = (XJV, HLM)
JLB = (MMR, HMQ)
GXX = (HLN, SGX)
PKX = (QKF, SHQ)
VND = (CDN, VVH)
HJG = (FXR, VDR)
GGR = (QRF, JMB)
BQG = (CRV, HHM)
RFS = (BHN, MNL)
CSK = (DCX, VXG)
RSL = (XCG, JGV)
KRH = (CKX, XVN)
VBP = (NLF, TVM)
AAA = (MQQ, VHH)
BVX = (LPG, LVL)
QCG = (JKJ, CDR)
JMQ = (HLR, GGT)
NLF = (RCG, TTX)
CXB = (NLG, HJS)
VXG = (SDN, FCJ)
XFT = (GNP, GGB)
SST = (GGS, PTC)
NNK = (PTD, HPF)
RKN = (XVF, MMX)
TGP = (SSN, MRT)
TSR = (SFK, RMV)
GBL = (NKQ, KVH)
NKJ = (CGM, TCP)
KVH = (VTK, GKV)
VBB = (DXX, JVB)
KGC = (HMK, TFL)
PNL = (QLT, PBD)
TNG = (QSG, TPL)
HCV = (KVR, PKK)
RBB = (TKG, CQK)
BJJ = (GCN, PLQ)
JRF = (DHC, XCQ)
FLJ = (CKP, KXQ)
KVR = (DJS, NKJ)
HGT = (KVX, LTP)
MGN = (JDS, LNS)
FRC = (QLM, FHJ)
MBN = (TRQ, MRD)
TMG = (CTD, SFH)
TNT = (JDG, HGV)
DXP = (SSX, DFT)
VVD = (JXJ, PGP)
CHL = (XSL, SNZ)
CGS = (GFQ, LRF)
BHL = (FNQ, HFD)
XHF = (NHD, PQC)
PMH = (CNS, SVM)
VKR = (TBT, TLT)
LLK = (TQD, BQN)
LVJ = (PDD, LML)
JPB = (PRK, VCV)
HSJ = (HBV, NRX)
VJH = (DTL, BRL)
SNJ = (DXP, CQV)
HQL = (KDL, QFN)
XHM = (HVG, ZZZ)
RDX = (KTM, MPJ)
MQQ = (LSC, DGG)
TMM = (GMQ, RTL)
JKP = (LRF, GFQ)
TKG = (BDN, BDN)
FBJ = (HLR, GGT)
PTD = (LMV, QBR)
FMB = (DQT, RRH)
TTX = (LVJ, FXX)
BXL = (BTQ, TTQ)
QMV = (GND, FGG)
HFD = (TBQ, VVD)
NFQ = (PMH, DMM)
RTH = (TPG, VDP)
VHH = (DGG, LSC)
HLN = (SPP, SPP)
XQD = (PNL, PFB)
GVD = (BPC, JJG)
XRN = (DHJ, LBD)
GNP = (NRC, NRC)
JLC = (JHB, DRK)
LGK = (BSK, BRV)
BSB = (MBM, XHF)
PBJ = (FRC, RFH)
DRH = (VMR, XVK)
RDF = (BHV, NGM)
MMR = (HGD, PBJ)
RGF = (HFD, FNQ)
HTR = (RCQ, KJC)
NGM = (FJP, LCZ)
PJF = (QKF, SHQ)
BCK = (XSX, XSX)
PBD = (SXM, HTT)
VCV = (GRD, VVT)
TFL = (CCX, HQB)
THT = (NXX, TSR)
JMS = (RCF, XRC)
FKG = (XRN, PHG)
TBQ = (PGP, JXJ)
SML = (TCH, DPF)
RJB = (RCF, XRC)
KJC = (LND, JNR)
HPT = (DLM, MVH)
NKM = (DQT, RRH)
JSJ = (QFH, STQ)
KJJ = (XXT, DBC)
FGG = (HPT, GMM)
RFH = (QLM, FHJ)
TLM = (DKN, QGH)
MJV = (QSG, TPL)
DHG = (RGT, CVS)
BVB = (QLJ, SNR)
RMH = (JKR, MRR)
XFX = (SNJ, QBD)
LNS = (SFQ, GGR)
QJV = (LRB, XFT)
BHV = (FJP, FJP)
JMT = (BJM, NPC)
BDN = (JFL, JFL)
CHC = (CXL, SXC)
VBN = (VBB, CFM)
SFQ = (QRF, JMB)
XXN = (JJG, BPC)
MCS = (TMG, DDQ)
CFV = (DHG, NKS)
FXK = (JSR, GLR)
JMB = (VSV, BCR)
VVT = (LST, GCJ)
VRL = (DJN, LLK)
XLB = (FGJ, PGB)
JVC = (XXT, DBC)
VQX = (BCD, VJK)
DVJ = (GCN, PLQ)
BTQ = (RCT, XVC)
LCX = (JHK, KPL)
FSD = (NNC, XLX)
TSQ = (FKM, HFJ)
HGD = (RFH, FRC)
HJL = (JDV, LNV)
FSB = (DBD, VCL)
DCX = (SDN, FCJ)
BHH = (JPK, GVQ)
JHB = (PTR, FSH)
THP = (SXC, CXL)
LRK = (QCT, FPT)
PTC = (LMF, DLF)
DHS = (HMQ, MMR)
GDK = (SNR, QLJ)
CNJ = (JKJ, CDR)
SBM = (BCT, XFS)
GJP = (RJK, DDX)
DFT = (KRX, MGK)
XBQ = (BNP, KKB)
FGJ = (VRL, CKV)
QVF = (XTM, XTM)
VJK = (BFB, CKT)
VJX = (BKD, LCD)
KQK = (GBL, HPK)
KKX = (BDC, SKC)
CRV = (HSJ, NTR)
JNR = (QCH, TTL)
HTG = (NQK, GJP)
QLN = (MNL, BHN)
GMB = (VVX, HTP)
JDG = (JDT, VCG)
QLT = (HTT, SXM)
CLK = (VJB, SRH)
GSX = (XKX, RSL)
MQX = (RTH, LPL)
ZZZ = (VHH, MQQ)
PKK = (DJS, NKJ)
MJT = (MQX, HTF)
GLT = (TCD, HXV)
PQX = (TGQ, JBF)
VSX = (LTP, KVX)
FSV = (FKG, NLC)
FKR = (CQD, JPR)
CKT = (RDX, DBQ)
JFD = (TKS, BBG)
CNM = (TBH, XRF)
PBC = (SNJ, QBD)
MRT = (QCG, CNJ)
RCQ = (JNR, LND)
JJG = (KNR, CGF)
CFP = (JVT, GSX)
BTG = (SBM, BRJ)
BJM = (CRK, HVD)
XVK = (CDS, BQF)
BCT = (BCK, CKG)
LST = (RFS, QLN)
DNM = (VMR, XVK)
GPB = (GNX, DJV)
FDR = (FTG, LFQ)
LCZ = (HFP, MPB)
XJV = (FCP, JHV)
HQC = (TRG, SCP)
RMD = (QMV, NNH)
SRH = (FLL, QKV)
QBD = (CQV, DXP)
RRH = (NCB, TSQ)
XVF = (NFB, NMN)
QMT = (GLT, NTS)
GBX = (TKG, CQK)
MFP = (TLH, QXD)
XKG = (MHN, NLR)
HQH = (HPF, PTD)
LLR = (CNR, CRF)
LSP = (SVQ, VJX)
HSH = (LRK, RLT)
TTL = (FKR, QMF)
CFB = (KDL, QFN)
SXG = (GNX, DJV)
LTP = (KJJ, JVC)
HSQ = (SPM, KRH)
SHG = (DRH, DNM)
DHJ = (QXR, GHK)
GGK = (PRK, VCV)
TRG = (PJN, CFV)
TTF = (LJV, LSQ)
VVH = (HSH, HDP)
QXR = (FNT, LCX)
DTL = (FSV, VQV)
KVX = (JVC, KJJ)
HLR = (BTG, MKN)
XCG = (QTJ, HTQ)
LML = (JMQ, FBJ)
FMS = (XTM, VXJ)
CTD = (JHQ, XLB)
TCD = (CSK, GLS)
MRR = (RQB, XTK)
SSN = (CNJ, QCG)
VLG = (NTS, GLT)
JDT = (JMS, RJB)
TPJ = (XFX, PBC)
PDD = (FBJ, JMQ)
QLJ = (NVL, JSJ)
TVX = (JPB, GGK)
QCT = (GBX, RBB)
GMM = (DLM, MVH)
RLT = (QCT, FPT)
PFH = (HTG, DNF)
DQN = (XCQ, DHC)
XQC = (QJQ, JLC)
QCH = (FKR, QMF)
GMQ = (KPJ, RTF)
HVJ = (QMV, NNH)
VDP = (TVX, VFB)
NXV = (DTL, BRL)
JHK = (MXJ, MBN)
JPK = (GQN, MFP)
SSH = (KQK, HLC)
FNB = (GPS, LLR)
HTP = (SPG, CSX)
HHN = (DNF, HTG)
QJQ = (JHB, DRK)
PFC = (KRJ, JLV)
HFP = (JRD, MMT)
HGC = (QCJ, CXG)
KLG = (BVX, QSM)
LHG = (HLM, XJV)
CGG = (QCK, RKN)
XVC = (CGS, JKP)
FCJ = (TMM, MBL)
KLC = (CDN, VVH)
CRF = (LVG, FNX)
PBP = (GSX, JVT)
GLS = (DCX, VXG)
DJD = (QGG, SST)
BJV = (DMP, HSQ)
MNL = (JSG, LNC)
DNF = (NQK, GJP)
NLR = (SSH, GHM)
HSP = (JBF, TGQ)
NRX = (DTX, CJK)
VVX = (CSX, SPG)
LSC = (DCL, QBB)
VXJ = (FLJ, PBZ)
CDR = (NXN, NMT)
SGM = (NXV, VJH)
XSX = (BHV, BHV)
MGK = (FXG, XTG)
VPC = (SKC, BDC)
HBV = (CJK, DTX)
RQB = (PCT, HTR)
FXR = (HKP, LVP)
BRL = (FSV, VQV)
VXK = (GVD, XXN)
SDN = (MBL, TMM)
FCP = (HXD, SHG)
XTG = (KLT, SPX)
LBD = (GHK, QXR)
JHQ = (FGJ, PGB)
XXT = (KNB, PQN)
VKC = (TCH, DPF)
GQN = (QXD, TLH)
HLM = (JHV, FCP)
JDK = (TTF, RGR)
VTS = (PMH, DMM)
VMR = (CDS, BQF)
XJA = (BHL, RGF)
MMS = (NLR, MHN)
DPF = (PQX, HSP)
NNH = (FGG, GND)
JSB = (NLG, HJS)
XLR = (GMB, HJK)
RCF = (VBP, SKL)
JPD = (HTF, MQX)
CJP = (DKN, QGH)
BLC = (HGV, JDG)
FTG = (PSL, TPJ)
JDS = (SFQ, GGR)
FQL = (JDV, LNV)
JBF = (CHC, THP)
HVG = (MQQ, VHH)
LKQ = (NLX, HHX)
KRX = (FXG, XTG)
JNA = (CKP, KXQ)
JPR = (CGD, BJH)
CJK = (MSQ, HCV)
QSM = (LVL, LPG)
BQN = (PCG, BJV)
SFH = (XLB, JHQ)
XLD = (QNN, LVC)
GTF = (HTB, RQV)
BMF = (QJQ, JLC)
THN = (XLM, DJD)
VPB = (FXR, VDR)
RQX = (XQD, JDL)
LNV = (XJG, FDR)
NXN = (DSS, KMF)
QTJ = (DKR, KLG)
VSV = (KHH, FSD)
DBD = (MGN, XFD)
DHC = (PHH, HQC)
QGH = (VBN, DPJ)
NTS = (TCD, HXV)
BSK = (BQG, HVR)
MRD = (VPB, HJG)
BQX = (BSK, BRV)
BRV = (BQG, HVR)
SVM = (PKX, PJF)
KRJ = (NMC, TBX)
GTH = (HVG, HVG)
SCP = (PJN, CFV)
CGF = (VFD, GXX)
SHQ = (THN, JNG)
JVT = (XKX, RSL)
RJK = (RVD, CLK)
MKN = (SBM, BRJ)
JHV = (HXD, SHG)
TLT = (JRF, DQN)
QBR = (NFQ, VTS)
CNR = (FNX, LVG)
LVG = (BJN, VXK)
FCQ = (BHL, RGF)
JXJ = (CFB, HQL)
DJV = (BXL, DTF)
DTX = (HCV, MSQ)
JLV = (NMC, TBX)
STQ = (RMH, XDG)
NQK = (DDX, RJK)
KTP = (RQV, HTB)
RLP = (JDL, XQD)
TQD = (PCG, BJV)
GGT = (MKN, BTG)
VJB = (FLL, QKV)
JVB = (MJT, JPD)
VQV = (FKG, NLC)
FXG = (KLT, SPX)
XFD = (LNS, JDS)
NKS = (CVS, RGT)
QFL = (GPS, LLR)
CDN = (HSH, HDP)
RTL = (RTF, KPJ)
CCX = (GPC, BVD)
CXG = (THT, VVN)
GRC = (CGG, RRL)
MXJ = (TRQ, MRD)
SXM = (HQH, NNK)
LJV = (SMP, VRJ)
RJD = (TKS, BBG)
HMQ = (PBJ, HGD)
MSQ = (KVR, PKK)
GPS = (CNR, CRF)
FNT = (KPL, JHK)
HDG = (LRB, XFT)
LFQ = (PSL, TPJ)
VFD = (HLN, SGX)
SKC = (CFP, PBP)
TKV = (HHX, NLX)
GPP = (TKV, LKQ)
JSG = (PFH, HHN)
BCD = (CKT, BFB)
MPJ = (HVJ, RMD)
GCT = (MRT, SSN)
XTM = (FLJ, FLJ)
DKN = (DPJ, VBN)
SVN = (VLG, QMT)
LQZ = (VJK, BCD)
PHS = (GPB, SXG)
XCQ = (HQC, PHH)
QNN = (FCQ, FCQ)
DMM = (CNS, SVM)
DBC = (PQN, KNB)
JFL = (XSL, XSL)
MBL = (RTL, GMQ)
VTK = (MGP, SVN)
SKL = (TVM, NLF)
HXD = (DRH, DNM)
GNX = (DTF, BXL)
XLM = (SST, QGG)
QMF = (CQD, JPR)
HMK = (HQB, CCX)
MMT = (BQX, LGK)
PJN = (DHG, NKS)
DGG = (DCL, QBB)
SPX = (XQC, BMF)
MHN = (SSH, GHM)
RDH = (TLT, TBT)
NMC = (KKX, VPC)
GKV = (SVN, MGP)
XSL = (LSP, TXX)
TGQ = (THP, CHC)
TRQ = (HJG, VPB)
VHK = (KRJ, JLV)
TPX = (MBM, XHF)
QXD = (QDM, PHS)
VRJ = (GDK, BVB)
KXQ = (RLP, RQX)
CNS = (PKX, PJF)
TPG = (TVX, VFB)
PTR = (QFL, FNB)
QHC = (KKB, BNP)
CDS = (VGC, LJC)
BTC = (MCS, DJB)
NLC = (PHG, XRN)
BDC = (CFP, PBP)
FPT = (GBX, RBB)
CQD = (BJH, CGD)
XKX = (JGV, XCG)
TXX = (VJX, SVQ)
SPP = (GTH, GTH)
KTM = (HVJ, RMD)
JGV = (HTQ, QTJ)
HKP = (KLC, VND)
GLR = (DVJ, BJJ)
LMF = (LHG, VLQ)
CLG = (TFL, HMK)
KHH = (NNC, XLX)
HTQ = (KLG, DKR)
QFN = (CNM, TCT)
FLL = (TNG, MJV)
HFV = (NPC, BJM)
NPC = (HVD, CRK)
HKK = (KGC, CLG)
XRF = (PFC, VHK)
GGS = (DLF, LMF)
LVC = (FCQ, PDZ)
DXX = (MJT, JPD)
DCL = (HGT, VSX)
LNC = (HHN, PFH)
TBT = (JRF, DQN)
DKR = (QSM, BVX)
KNL = (QCJ, CXG)
TLH = (PHS, QDM)
NMT = (DSS, KMF)
HLC = (GBL, HPK)
BDX = (TTF, RGR)
HXV = (GLS, CSK)
TBH = (VHK, PFC)
QBB = (HGT, VSX)
TCH = (PQX, HSP)
QFH = (XDG, RMH)
GND = (HPT, GMM)
CVS = (QJV, HDG)
FNQ = (VVD, TBQ)
NCB = (FKM, FKM)
FHJ = (MMS, XKG)
VFB = (GGK, JPB)
RQV = (KKC, BTC)
NLX = (KNL, HGC)
TCT = (XRF, TBH)
GGB = (NRC, XLD)
JKJ = (NXN, NMT)
SPG = (DHS, JLB)
LVP = (VND, KLC)
NPJ = (KGC, CLG)
RVD = (SRH, VJB)
HTT = (NNK, HQH)
PQC = (TGP, GCT)
MPB = (MMT, JRD)
BCR = (FSD, KHH)
BHN = (LNC, JSG)
SMP = (BVB, GDK)
GPC = (NLB, FSB)
NMD = (GTH, XHM)
CGD = (SML, VKC)
CKP = (RQX, RLP)
DQT = (NCB, NCB)
KDL = (CNM, TCT)
CQK = (BDN, KSC)
NXX = (SFK, RMV)
RTF = (LJM, SGM)
KQQ = (HJK, GMB)
KMF = (BVK, BHH)
HPK = (KVH, NKQ)
PLQ = (MLH, PTP)
RCG = (LVJ, FXX)
HPF = (LMV, QBR)
TBX = (VPC, KKX)
NKQ = (VTK, GKV)
PRK = (GRD, VVT)
TPL = (QVF, FMS)
CFM = (DXX, JVB)
SGX = (SPP, NMD)
MLH = (KQQ, XLR)
NNC = (TNT, BLC)
XLX = (TNT, BLC)
MBM = (NHD, PQC)
PHH = (TRG, SCP)
QKV = (TNG, MJV)
XJG = (FTG, LFQ)
QCK = (XVF, MMX)
SVQ = (LCD, BKD)
SXC = (FMB, NKM)
RCT = (CGS, JKP)
KNR = (VFD, GXX)
FKM = (VQX, VQX)
CKV = (DJN, LLK)
DDX = (CLK, RVD)
GCN = (PTP, MLH)
BFB = (DBQ, RDX)
SNZ = (TXX, LSP)
MVH = (JMX, GRC)
HHX = (HGC, KNL)
GRD = (GCJ, LST)
SPM = (CKX, XVN)
LPL = (VDP, TPG)
CGM = (BSB, TPX)
FXX = (LML, PDD)
PGB = (CKV, VRL)
MMX = (NMN, NFB)
DJS = (TCP, CGM)
HTF = (LPL, RTH)
DSS = (BVK, BHH)
KPJ = (SGM, LJM)
DLM = (GRC, JMX)
LSQ = (SMP, VRJ)
SNR = (NVL, JSJ)
DPJ = (CFM, VBB)
DDQ = (SFH, CTD)
VVN = (NXX, TSR)
QLM = (XKG, MMS)
QCJ = (VVN, THT)
JDL = (PFB, PNL)
DLF = (LHG, VLQ)
LJC = (JMT, HFV)
GVQ = (GQN, MFP)
XTK = (HTR, PCT)
NRC = (QNN, QNN)
PHG = (DHJ, LBD)
BVD = (NLB, FSB)
VDR = (HKP, LVP)
BVK = (GVQ, JPK)
FLB = (JSR, GLR)